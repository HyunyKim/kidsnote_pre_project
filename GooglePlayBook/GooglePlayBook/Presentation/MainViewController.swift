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
import GoogleSignIn

//protocol GoogleLoginDelegate: AnyObject {
//    func getGoogleInstance() -> GIDSignInResult?
//}

final class MainViewController: UIViewController {
    //UIComponents
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.searchBar.autocapitalizationType = .none
        searchController.view.backgroundColor = .background
        return searchController
    }()
    
    private lazy var searchResultController: SearchResultViewController = {
        let controller = SearchResultViewController(delegate: self)
        return controller
    }()
    
    private lazy var googleButton: UIButton = {
        let button = UIButton(type: .system)
//        button.setTitle("SignIn", for: .normal)
        return button
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
        self.view.backgroundColor = .background
        self.navigationItem.title = "Google Play Book Search"
        
        view.addSubview(googleButton)
        googleButton.snp.makeConstraints { make in
            make.height.equalTo(50.0)
            make.width.equalTo(200.0)
            make.bottom.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }
        googleButton.addTarget(self, action: #selector(googleLoginAction), for: .touchUpInside)
        googleButton.setBackgroundImage(
            traitCollection.userInterfaceStyle != .dark ? .iosNeutralRdSI : .iosDarkRdSI, for: .normal)
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
    
    @objc private func googleLoginAction(_ sender: UIControl) {
        GoogleManager.share.googleLogin()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        googleButton.setBackgroundImage(
            previousTraitCollection?.userInterfaceStyle == .dark ? .iosNeutralRdSI : .iosDarkRdSI, for: .normal)
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

extension MainViewController: SearchResultVCDelegate {
    func dideBookSelectedItem(itemId: String) {
        let detaiVC = BookDetailViewController(bookId: itemId)
        self.navigationController?.pushViewController(detaiVC, animated: true)
    }
    
    func didBookshelfSelectedItem(itemId: Int) {
        guard let instance = GoogleManager.share.getGoogleInstance() else { return }
        let shelfVC = BookshelfViewController(shelfId: itemId, googleResult: instance)
        self.navigationController?.pushViewController(shelfVC, animated: true)
    }
}
