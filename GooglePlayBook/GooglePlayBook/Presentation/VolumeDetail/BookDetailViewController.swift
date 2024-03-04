//
//  BookDetailViewController.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import LevelOSLog

class BookDetailViewController: UIViewController {

    // UIComponents
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        return collectionView
    }()
    
    // Variable
    private var disposeBag = DisposeBag()
    @Inject private var viewModel: BookViewModel
    private let loadInfoSubject = PublishSubject<String>()
    private var bookId: String
    
    init(bookId: String) {
        self.bookId = bookId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        bindingUI()
        bindingViewModel()
        loadInfoSubject.onNext(bookId)
    }

    @objc private func backAction(sender: UIControl) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func layoutUI() {
        
        
        let barbuttonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backAction))
        barbuttonItem.tintColor = .textColor1
        navigationItem.leftBarButtonItem = barbuttonItem
        navigationItem.title = "도서 정보"
        
        view.backgroundColor = .background
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.backgroundColor = .background
    }
    
    private func bindingUI() {

    }
    
    private func bindingViewModel() {
        
        let output = viewModel.transform(input: .init(loadInfoAction: loadInfoSubject))
        output.bookInfo
            .asObservable()
            .subscribe { (result: Swift.Result<BookDetailInfo,Error>) in
                switch result {
                case .success(let bookInfo):
                    Log.debug(bookInfo)
                case .failure(let error):
                    Log.error(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}
