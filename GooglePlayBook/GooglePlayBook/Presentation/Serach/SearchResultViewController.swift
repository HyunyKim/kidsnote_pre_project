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
import LevelOSLog

final class SearchResultViewController: UIViewController {
// UIComponents
    private let tableView: UITableView = UITableView()
    private let segmentControll: UISegmentedControl = TopSegmentControl(items: ["Ebook","AudioBook"])
    
// Variable
    @Inject private var viewModel: SearchViewModel
    private var dispoasBag = DisposeBag()
    private let loadMoreSubject = PublishSubject<Void>()
    let searchKeywordSubject = PublishSubject<String>()
    
    override func viewDidLoad() {
        setUI()
        setdConstraints()
        bindViewModel()
    }
    
    private func setUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(segmentControll)

        segmentControll.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
        segmentControll.setTitleTextAttributes([.foregroundColor: UIColor.blue, .font: UIFont.systemFont(ofSize: 13,weight: .semibold)], for: .selected)
        segmentControll.selectedSegmentIndex = 0
    }
    
    private func setdConstraints() {
        
        segmentControll.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top).offset(self.navigationController?.navigationBar.safeAreaInsets.top ?? 100)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(searchKeyword: searchKeywordSubject, loadMoreAction: loadMoreSubject))
        
        output.searchResult
            .drive { container in
                Log.debug("result", container)
            }
            .disposed(by: dispoasBag)
    }

}
