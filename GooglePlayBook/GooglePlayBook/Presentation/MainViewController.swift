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
        button.setTitle("SignIn", for: .normal)
        return button
    }()
    
    //Variables
    private var googleResult: GIDSignInResult? = nil
    private var typeingKeyword: String = ""
    private var typingSubject = PublishSubject<String>()
    private var disposeBag = DisposeBag()
    private let scopeURLString = "https://www.googleapis.com/auth/books"
    
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
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.center.equalToSuperview()
        }
        googleButton.addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
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
    
    @objc private func googleLogin(sender: UIControl) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {[weak self] result, error in
            guard error == nil else {
                print("error",error ?? "")
                return
            }
            self?.googleResult = result
            self?.additionalScope()
        }
    }
    
    private func additionalScope() {
        if let googleInstance = googleResult {
            let driveScope = scopeURLString
            let grantedScopes = googleInstance.user.grantedScopes
            if grantedScopes == nil || !grantedScopes!.contains(driveScope) {
                self.refreshCheck()
            }
            let additionalScopes = [scopeURLString]

            googleInstance.user.addScopes(additionalScopes, presenting: self) {[weak self] signInResult, error in
                guard error == nil else {
                    return
                }
                guard let signInResult = signInResult else { return }
                self?.googleResult = signInResult

                // Check if the user granted access to the scopes you requested.
                
            }
        }
    }
    
    func refreshCheck() {
        if let googleInstance = self.googleResult {
            googleInstance.user.refreshTokensIfNeeded { user, error in
                guard error == nil else { return }
                guard let user = user else { return }
                let accessToken = user.accessToken.tokenString
                let authorizer = googleInstance.user.fetcherAuthorizer
                print("check ",googleInstance.user.accessToken.tokenString, accessToken)
            }
        }
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
    func didSelectedItem(itemId: String) {
        let detaiVC = BookDetailViewController(bookId: itemId)
        self.navigationController?.pushViewController(detaiVC, animated: true)
    }
    
    func getGoogleInstance() -> GIDSignInResult? {
        return self.googleResult
    }
}
