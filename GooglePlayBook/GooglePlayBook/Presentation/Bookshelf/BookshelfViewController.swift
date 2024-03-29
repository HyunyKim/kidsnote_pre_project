//
//  BookshelfViewController.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/6/24.
//

import UIKit
import SnapKit
import GoogleSignIn
import RxSwift
import RxCocoa
import RxDataSources

class BookshelfViewController: UIViewController, BookCollectionViewLayout {
    
    private lazy var collectionView: UICollectionView = {
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createShelfListLayout())
        collectionview.backgroundColor = .background
        collectionview.showsVerticalScrollIndicator = false
        return collectionview
    }()
    
    private var shelfId: Int = -1
    private var googleInstance: GIDSignInResult
    private var disposeBag = DisposeBag()
    private var requestAction = PublishSubject<(key: String, shelfId: Int)>()
    private let loadMoreAction = PublishSubject<Int>()
    private let sectionModelSubject = BehaviorSubject<[SearchResultSectionModel]>(value: [])
    private var shelfTitle: String
    @Inject var viewModel: BookshelfViewModel
    
    init(shelfId: Int, googleResult: GIDSignInResult, shelfTitle: String) {
        self.shelfId = shelfId
        self.googleInstance = googleResult
        if shelfTitle.isEmpty {
            self.shelfTitle = "MySehlf (\(shelfId)"
        } else {
            self.shelfTitle = shelfTitle
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        registerCell()
        bindingUI()
        bindingViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.requestAction.onNext((key: self.googleInstance.user.accessToken.tokenString, shelfId: self.shelfId))
    }
    
    @objc private func backAction(sender: UIControl) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func registerCell() {
        collectionView.register(EBookInfoCell.self, forCellWithReuseIdentifier: EBookInfoCell.identifier)
        collectionView.register(LoadMoreCell.self, forCellWithReuseIdentifier: LoadMoreCell.identifier)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: EmptyCell.identifier)
        collectionView.register(SearchResultResuableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchResultResuableView.identifier)
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
        navigationItem.title = shelfTitle
        let barbuttonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backAction))
        barbuttonItem.tintColor = .textColor1
        navigationItem.leftBarButtonItem = barbuttonItem
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).inset(self.view.safeAreaInsets.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func bindingUI() {
        sectionModelSubject
            .bind(to: collectionView.rx.items(dataSource: sectionReloadDataSource()))
            .disposed(by: disposeBag)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(SearchResultSectionItem.self)
            .observe(on: MainScheduler.instance)
            .subscribe {[weak self] item in
                switch item {
                case .eBookItem(let item):
                    self?.goBookDetail(itemId: item.id)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindingViewModel() {
        let output = viewModel.transform(input: .init(getShelfAction: requestAction,loadMoreAction: loadMoreAction))
        
        output.volumeList
            .drive { [weak self] result in
                switch result {
                case .success(let items):
                    self?.sectionModelSubject.onNext(self?.emitDataMysheifVoloumSource(items: items.items, hasMore: items.hasMore) ?? [])
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
                    
                case .eBookItem(item: let item):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EBookInfoCell.identifier, for: indexPath) as! EBookInfoCell
                    cell.updateUI(ebook: item)
                    
                    return cell
                case.emptyView:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.identifier, for: indexPath) as! EmptyCell
                    cell.updateTitle(title: "서가에 책이 없습니다")
                    return cell
                case .loadMore:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadMoreCell.identifier, for: indexPath) as! LoadMoreCell
                    return cell
                default:
                    return UICollectionViewCell()
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchResultResuableView.identifier, for: indexPath) as! SearchResultResuableView
                header.updateUI(type: .myLibrarySearchResult)
                return header
            }
        )
    }
    
    private func goBookDetail(itemId: String) {
        let detaiVC = BookDetailViewController(bookId: itemId)
        self.navigationController?.pushViewController(detaiVC, animated: true)
        
    }
}

extension BookshelfViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell.isKind(of: LoadMoreCell.self) {
            self.loadMoreAction.onNext(indexPath.item)
        }
    }
}
