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
import RxDataSources
import LevelOSLog

class BookDetailViewController: UIViewController {

    // UIComponents
    private lazy var tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    private lazy var tableHeaderView: BookDisplayInfoView = {
        let view = BookDisplayInfoView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        return view
    }()
    
    // Variable
    private var disposeBag = DisposeBag()
    @Inject private var viewModel: BookViewModel
    private let loadInfoSubject = PublishSubject<String>()
    private let sectionModelSubject = BehaviorSubject<[BookDetailInfoSectionModel]>(value: [])
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
        registerCell()
        bindingUI()
        bindingViewModel()
        loadInfoSubject.onNext(bookId)
    }
    
    private func registerCell() {
        tableView.register(BookUserActionCell.self, forCellReuseIdentifier: BookUserActionCell.identifier)
        tableView.register(BookDescriptionCell.self, forCellReuseIdentifier: BookDescriptionCell.identifier)
        tableView.register(BookRatingInfoCell.self, forCellReuseIdentifier: BookRatingInfoCell.identifier)
        tableView.register(BookPublishInfoCell.self, forCellReuseIdentifier: BookPublishInfoCell.identifier)
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
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.backgroundColor = .background
        tableView.tableHeaderView = self.tableHeaderView
        tableView.separatorInset = .zero
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
//        tableHeaderView.snp.makeConstraints { make in
//            make.height.greaterThanOrEqualTo(150)
//        }
    }
    
    private func bindingUI() {
        
        let sectionDataSource = sectionReloadDataSource()
        
        sectionModelSubject
            .bind(to: tableView.rx.items(dataSource: sectionDataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(BookDetailSectionItem.self)
            .subscribe(onNext: {[weak self] item in
                switch item {
                case .userAction(webreaderLink: let link):
                    return
                case .bookDescription(description: let description):
                    Log.debug("description", description)
                case .ratingInfo(item: let item):
                    Log.debug("rating", item)
                case .publishInfo(publishing: let publishing):
                    Log.debug("publishing", publishing)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bindingViewModel() {
        
        let output = viewModel.transform(input: .init(loadInfoAction: loadInfoSubject))
        output.bookInfo
            .asObservable()
            .subscribe { [weak self] (result: Swift.Result<BookDetailInfo,Error>) in
                switch result {
                case .success(let bookInfo):
                    Log.debug(bookInfo)
                    self?.tableHeaderView.updateUI(bookInfo: bookInfo)
                    self?.tableView.tableHeaderView = self?.tableHeaderView
                    self?.emitDataSource(data: bookInfo)
                case .failure(let error):
                    Log.error(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func emitDataSource(data: BookDetailInfo) {
        let tableItems: [BookDetailSectionItem] = [
            .userAction(webreaderLink: data.webReaderLink),
            .bookDescription(description: ""),
            .ratingInfo(item: data),
            .publishInfo(publishing: "")
        ]
        let bookSectionModel = BookDetailInfoSectionModel.bookInformationSection(items: tableItems)
        sectionModelSubject.onNext([bookSectionModel])
    }
    
    private func sectionReloadDataSource() -> RxTableViewSectionedReloadDataSource<BookDetailInfoSectionModel> {
        return RxTableViewSectionedReloadDataSource { dataSource, tableView, indexPath, item in
            switch item {
            
            case .userAction(webreaderLink: let link):
                 let cell = tableView.dequeueReusableCell(withIdentifier: BookUserActionCell.identifier) as! BookUserActionCell
                cell.sampleURLString = link
                return cell
            case .bookDescription(description: let description):
                let cell = tableView.dequeueReusableCell(withIdentifier: BookDescriptionCell.identifier) as! BookDescriptionCell
               return cell
            case .ratingInfo(item: let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: BookRatingInfoCell.identifier) as! BookRatingInfoCell
               return cell
            case .publishInfo(publishing: let publishing):
                let cell = tableView.dequeueReusableCell(withIdentifier: BookPublishInfoCell.identifier) as! BookPublishInfoCell
               return cell
            }
        }
    }
}
