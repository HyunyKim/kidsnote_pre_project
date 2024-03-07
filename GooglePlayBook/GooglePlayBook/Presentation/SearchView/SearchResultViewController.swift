//
//  SearchResultViewController.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import LevelOSLog
import GoogleSignIn

protocol SearchResultVCDelegate: AnyObject {
    func dideBookSelectedItem(itemId: String)
    func didBookshelfSelectedItem(itemId: Int, title: String)
}

final class SearchResultViewController: UIViewController, BookCollectionViewLayout {
    // UIComponents
    private lazy var collectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createEBookListLayout())
        collectionview.backgroundColor = .background
        collectionview.showsVerticalScrollIndicator = false
        return collectionview
    }()
    
    private var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var refreshControl: UIRefreshControl = UIRefreshControl()
    
    // Variable
    @Inject private var viewModel: SearchViewModel
    private var disposeBag = DisposeBag()
    private let loadMoreSubject = PublishSubject<Int>()
    private let myLibraryAction = PublishSubject<String>()
    private let segmentAction = PublishSubject<Int>()
    private let sectionModelSubject = BehaviorSubject<[SearchResultSectionModel]>(value: [])
    let searchKeywordSubject = PublishSubject<String>()
    let typingSubject = PublishSubject<String>()
    weak var delegate: SearchResultVCDelegate?
    var segmentSelectedIndex: Int = 0
    
    init(delegate: SearchResultVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        layoutUI()
        registerCell()
        bindingUI()
        bindingViewModel()
    }
    
    private func registerCell() {
        collectionView.register(EBookInfoCell.self, forCellWithReuseIdentifier: EBookInfoCell.identifier)
        collectionView.register(LoadMoreCell.self, forCellWithReuseIdentifier: LoadMoreCell.identifier)
        collectionView.register(MyLibrarayCell.self, forCellWithReuseIdentifier: MyLibrarayCell.identifier)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: EmptyCell.identifier)
        collectionView.register(SearchResultResuableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchResultResuableView.identifier)
        collectionView.register(TopSegmentReuseableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TopSegmentReuseableView.identifier)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        collectionView.snp.removeConstraints()
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(self.view.safeAreaInsets.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func layoutUI() {
        view.backgroundColor = .background
        
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(self.view.safeAreaInsets.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        collectionView.refreshControl = refreshControl
        collectionView.isHidden = true
    }
    
    private func bindingUI() {
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        sectionModelSubject
            .bind(to: collectionView.rx.items(dataSource: sectionReloadDataSource()))
            .disposed(by: disposeBag)
        
        searchKeywordSubject
            .subscribe(onNext: { [weak self] _ in
                self?.loadingIndicator.isHidden = false
                self?.loadingIndicator.startAnimating()
            })
            .disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(SearchResultSectionItem.self)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] sectionItem in
                guard let delegate = self?.delegate else { return }
                switch sectionItem {
                case .eBookItem(let item):
                    delegate.dideBookSelectedItem(itemId: item.id)
                case .bookshelf(let item):
                    delegate.didBookshelfSelectedItem(itemId: item.id, title: item.title ?? "")
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func bindingViewModel() {
        
        let controlChange = refreshControl.rx
            .controlEvent(.valueChanged)
            .map({[weak self] in
                return self?.viewModel.searchedKeyword ?? ""
            })
        
        let merged = Observable<String>
            .merge(searchKeywordSubject,controlChange)
        
        let output = viewModel.transform(input: .init(searchAction: merged,
                                                      typingAction: typingSubject,
                                                      loadMoreAction: loadMoreSubject,
                                                      searchMylibraryAction: myLibraryAction,
                                                      segmentAction: segmentAction))
        
        output.searchResult
            .drive(onNext: { [weak self] result in
                self?.loadingIndicator.isHidden = true
                self?.collectionView.isHidden = false
                self?.refreshControl.endRefreshing()
                switch result {
                case .success(let items):
                    self?.segmentSelectedIndex = 0
                    self?.sectionModelSubject.onNext(self?.emitDataEBookSource(items: items.items, hasMore: items.hasMore) ?? [])
                    
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
        
        output.resetValue
            .map { _ in
                self.collectionView.isHidden
            }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] value in
                DispatchQueue.main.async {
                    self?.sectionModelSubject.onNext(self?.emitDataEBookSource(items: [], hasMore: false) ?? [])
                    self?.collectionView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        output.mylibraryResult
            .drive { [weak self]  (result: Swift.Result<MyLibrary,Error>) in
                switch result {
                case .success((let myLibrary)):
                    self?.sectionModelSubject.onNext(self?.emitDataMylibrary(items: myLibrary.items) ?? [] )
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func sectionReloadDataSource() -> RxCollectionViewSectionedReloadDataSource<SearchResultSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<SearchResultSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch item {
                case .segment:
                    return UICollectionViewCell()
                case .eBookItem(item: let item):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EBookInfoCell.identifier, for: indexPath) as! EBookInfoCell
                    cell.updateUI(ebook: item)
                    
                    return cell
                case .loadMore:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadMoreCell.identifier, for: indexPath) as! LoadMoreCell
                    
                    return cell
                    
                case .bookshelf(item: let item):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyLibrarayCell.identifier, for: indexPath) as! MyLibrarayCell
                    cell.updateUI(libraryInfo: item)
                    return cell
                case .emptyView:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.identifier, for: indexPath) as! EmptyCell
                    return cell
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                switch indexPath.section {
                case 0:
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TopSegmentReuseableView.identifier, for: indexPath) as! TopSegmentReuseableView
                    header.delegate = self
                    header.segmentChangeAction(index: self.segmentSelectedIndex)
                    return header
                case 1:
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchResultResuableView.identifier, for: indexPath) as! SearchResultResuableView
                    header.updateUI(type: self.segmentSelectedIndex == 0 ? .googlePlaySearchResult : .myLibrarySearchResult )
                    return header
                default:
                    return UICollectionReusableView()
                }
            })
    }
}
extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell.isKind(of: LoadMoreCell.self) {
            loadMoreSubject.onNext(indexPath.item)
        }
    }
}

extension SearchResultViewController: TopSegmentSegmentDelegate {
    
    func stateChange(index: Int) {
        self.segmentSelectedIndex = index
        switch TopSegmentReuseableView.SegmentIndex(rawValue: index) {
        case .eBook:
            self.segmentAction.onNext(index)
        case .myLibrary:
            
            if let googleInstance = GoogleManager.share.getGoogleInstance() {
                let key = googleInstance.user.accessToken.tokenString
                self.myLibraryAction.onNext(key)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.segmentSelectedIndex = 0
                    self.collectionView.reloadData()
                }
            }
        case .none:
            break
        }
    }
}
