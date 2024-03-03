//
//  MainViewController.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

final class MainViewController: UIViewController {
    //UIComponents
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.searchBar.autocapitalizationType = .none
        return searchController
    }()
    
    private lazy var searchResultController: SearchResultViewController = {
        let controller = SearchResultViewController()
        return controller
    }()
    
    //Variables
    
    private var searchText: String = ""
    private var inputKeyword = PublishSubject<String>()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "Google Play Book Search"
        configureSearchBar()
        bindingUI()
    }
    
    private func configureSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func bindingUI() {
        let searchKeyword = searchController.searchBar.rx.searchButtonClicked
            .compactMap { [weak self] _ -> String? in
                self?.searchController.searchBar.text
            }.share()
        searchKeyword.bind(to: searchResultController.searchKeywordSubject)
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text ?? ""
    }
    
    
}
