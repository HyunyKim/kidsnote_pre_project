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

protocol SearchResultVCDelegate: AnyObject {
    func didSelectedItem(itemId: String)
}

final class SearchResultViewController: UIViewController {
    // UIComponents
    private lazy var collectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createBasicLayout())
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
    private let loadMoreSubject = PublishSubject<Void>()
    private let sectionModelSubject = BehaviorSubject<[SearchResultSectionModel]>(value: [])
    let searchKeywordSubject = PublishSubject<String>()
    let typingSubject = PublishSubject<String>()
    weak var delegate: SearchResultVCDelegate?
    
    init(delegate: SearchResultVCDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        layoutUI()
        bindingUI()
        bindingViewModel()
    }
    
    private func createBasicLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 0
            switch sectionIndex {
            case 0,1:
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [header]
            default:
                break
            }
            return section
        }
        return layout
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
        self.view.backgroundColor = .background
        
        self.view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(self.view.safeAreaInsets.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        collectionView.register(EBookInfoCell.self, forCellWithReuseIdentifier: EBookInfoCell.identifier)
        collectionView.register(LoadMoreCell.self, forCellWithReuseIdentifier: LoadMoreCell.identifier)
        collectionView.register(SearchResultResuableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchResultResuableView.identifier)
        collectionView.register(TopSegmentReuseableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TopSegmentReuseableView.identifier)
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
                switch sectionItem {
                case .eBookItem(let item):
                    guard let delegate = self?.delegate else { return }
                    delegate.didSelectedItem(itemId: item.id)
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
                                                      loadMoreAction: loadMoreSubject))
        
        output.searchResult
            .drive(onNext: { [weak self] result in
                self?.loadingIndicator.isHidden = true
                self?.collectionView.isHidden = false
                self?.refreshControl.endRefreshing()
                switch result {
                case .success(let result):
                    self?.emitDataSource(items: result.items, hasMore: result.hasMore)
                case .failure(let error):
                    Log.error("Error", error)
                }
            })
            .disposed(by: disposeBag)
        
        output.restValues
            .map { _ in
                self.collectionView.isHidden
            }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] value in
                DispatchQueue.main.async {
                    self?.emitDataSource(items: [], hasMore: false)
                    self?.collectionView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func emitDataSource(items: [EBook], hasMore: Bool) {
        let segmentSection = SearchResultSectionModel.segmentSection
        let ebookItemSection = SearchResultSectionModel.eBookItemSection(items: items.map {
            SearchResultSectionItem.eBookItem(item: $0) })
        let loadMoreSection = SearchResultSectionModel.loadMoreSection(item: hasMore ? [SearchResultSectionItem.loadMore] : [])
        sectionModelSubject.onNext([segmentSection,ebookItemSection,loadMoreSection])
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
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                switch indexPath.section {
                case 0:
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TopSegmentReuseableView.identifier, for: indexPath) as! TopSegmentReuseableView
                    return header
                case 1:
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchResultResuableView.identifier, for: indexPath) as! SearchResultResuableView
                    header.updateUI(type: .googlePlaySearchResult )
                    return header
                default:
                    return UICollectionReusableView()
                }
            })
    }
}
extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 2 , indexPath.row == 0 {
            loadMoreSubject.onNext(())
        }
    }
}
