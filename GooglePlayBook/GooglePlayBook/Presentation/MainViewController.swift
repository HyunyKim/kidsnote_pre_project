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
        searchController.view.backgroundColor = UIColor(resource: .background)
        return searchController
    }()
    
    private lazy var searchResultController: SearchResultViewController = {
        let controller = SearchResultViewController()
        return controller
    }()
    
    //Variables
    
    private var typeingKeyword: String = ""
    private var typingSubject = PublishSubject<String>()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureSearchBar()
        bindingUI()
    }
    
    private func layoutUI() {
        self.view.backgroundColor = UIColor(resource: .background)
        self.navigationItem.title = "Google Play Book Search"
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
        
        typingSubject.bind(to: searchResultController.typingSubject)
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBarText = searchController.searchBar.text ?? ""
        if searchBarText != typeingKeyword {
            typingSubject.onNext(searchBarText)
        }
        typeingKeyword = searchBarText
    }
    
    
}
