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
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: createListLayout())
        collectionview.backgroundColor = .background
        collectionview.showsVerticalScrollIndicator = false
        return collectionview
    }()
    
    private var shelfId: Int = -1
    private var googleInstance: GIDSignInResult
    private var disposeBag = DisposeBag()
    private var requestAction = PublishSubject<(key: String, shelfId: Int)>()
    private let sectionModelSubject = BehaviorSubject<[SearchResultSectionModel]>(value: [])
    @Inject var viewModel: BookshelfViewModel
    
    init(shelfId: Int, googleResult: GIDSignInResult) {
        self.shelfId = shelfId
        self.googleInstance = googleResult
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backAction))
        
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
    }
    
    private func bindingViewModel() {
        let output = viewModel.transform(input: .init(getShelfAction: requestAction))
        
        output.volumeList
            .drive { [weak self] result in
                switch result {
                case .success(let items):
                    self?.sectionModelSubject.onNext(self?.emitDataBookShelf(items: items) ?? [])
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
    
}
