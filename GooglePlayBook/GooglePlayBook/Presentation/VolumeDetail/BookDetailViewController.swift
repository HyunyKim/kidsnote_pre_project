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

final class BookDetailViewController: UIViewController {

    // UIComponents
    private lazy var tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    // Variable
    private var disposeBag = DisposeBag()
    @Inject private var viewModel: BookViewModel
    private let loadInfoAction = PublishSubject<String>()
    private let addMyShelfAction = PublishSubject<(key: String,shelfId: Int,volumeId:String)>()
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
        loadInfoAction.onNext(bookId)
    }
    
    private func registerCell() {
        tableView.register(BookMainInfoCell.self, forCellReuseIdentifier: BookMainInfoCell.identifier)
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
        tableView.separatorInset = .zero
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .none

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
                case .bookDescription(description: let description, title: let title):
//                    Log.debug("전달", description)
                    DispatchQueue.main.async {
                        let viewController = DescriptionViewController(description: description, title: title)
                        self?.navigationController?.pushViewController(viewController, animated: true)
                    }
                    return
                case .ratingInfo(item: _):
                    return
                default:
                    return
                    
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bindingViewModel() {
        
        let output = viewModel.transform(input: .init(loadInfoAction: loadInfoAction,addMyShelfAction: addMyShelfAction))
        output.bookInfo
            .asObservable()
            .subscribe { [weak self] (result: Swift.Result<BookDetailInfo,Error>) in
                switch result {
                case .success(let bookInfo):
                    self?.emitDataSource(data: bookInfo)
                case .failure(let error):
                    Log.error(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        output.addResult
            .subscribe(onNext:{ [weak self] in
                self?.showAlert(message: "추가되었습니다")
            },onError: {[weak self] error in
                self?.showAlert(message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func emitDataSource(data: BookDetailInfo) {
        var tableItems: [BookDetailSectionItem] = [
            .bookMainInfo(item: data),
            .userAction(webreaderLink: data.webReaderLink)]
        if data.selfLink != nil {
            tableItems.append(.ratingInfo(item: data))
        }
        if let desc = data.description, !desc.isEmpty, let title = data.title {
            tableItems.append(.bookDescription(description: desc,title: title))
        }
        tableItems.append(.publishInfo(publishing: data.publisherInfo()))
        let bookSectionModel = BookDetailInfoSectionModel.bookInformationSection(items: tableItems)
        sectionModelSubject.onNext([bookSectionModel])
    }
    
    private func sectionReloadDataSource() -> RxTableViewSectionedReloadDataSource<BookDetailInfoSectionModel> {
        return RxTableViewSectionedReloadDataSource { dataSource, tableView, indexPath, item in
            switch item {
                
            case .bookMainInfo(item: let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: BookMainInfoCell.identifier) as! BookMainInfoCell
                cell.updateUI(bookInfo: item)
                return cell
            case .userAction(webreaderLink: let link):
                 let cell = tableView.dequeueReusableCell(withIdentifier: BookUserActionCell.identifier) as! BookUserActionCell
                cell.sampleURLString = link
                cell.delegate = self
                return cell
            case .bookDescription(description: let description, title: _):
                let cell = tableView.dequeueReusableCell(withIdentifier: BookDescriptionCell.identifier) as! BookDescriptionCell
                cell.updateDescription(text: description)
               return cell
            case .ratingInfo(item: let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: BookRatingInfoCell.identifier) as! BookRatingInfoCell
                cell.updateRatingInfo(info: item)
                
               return cell
            case .publishInfo(publishing: let publishing):
                let cell = tableView.dequeueReusableCell(withIdentifier: BookPublishInfoCell.identifier) as! BookPublishInfoCell
                cell.updatePublishInfo(info: publishing)
               return cell
            }
        }
    }
}

extension BookDetailViewController: BookActiondelegate {
    func emptySampleURL() {
        self.showAlert(message: "샘플이 없습니다")
    }
    
    /// To Read서가로 고정합니다
    func addMylibrary() {
        guard let googleInstance = GoogleManager.share.getGoogleInstance() else {
            return
        }
        addMyShelfAction.onNext((key: googleInstance.user.accessToken.tokenString, shelfId: 2, volumeId: bookId))
        
    }
    
    func removeMyLibrary() {
        
    }
    
    
}
