//
//  GoogleManager.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/7/24.
//

import Foundation
import GoogleSignIn

final class GoogleManager {
    static let share = GoogleManager()
    private init() {}

    private var signInResult: GIDSignInResult? = nil
    private let scopeURLString = "https://www.googleapis.com/auth/books"
    
    func getHiehestViewController() -> UIViewController? {
        let activeScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive })
        if let windowScene = activeScene as? UIWindowScene {
            let window = windowScene.windows.first { $0.isKeyWindow }
            var currentViewController = window?.rootViewController
            while let presentedViewController = currentViewController?.presentedViewController {
                currentViewController = presentedViewController
            }
            return currentViewController
        }
        return nil
    }
    
    func getGoogleInstance() -> GIDSignInResult? {
        guard let instance = signInResult else {
            if let highestVC = getHiehestViewController() {
                let buttonAction = { (action: UIAlertAction) in
                    GoogleManager.share.googleLogin()
                }
                highestVC.showAlert(message: "Google Login이 필요합니다",button1Completion: buttonAction)
            }
            return nil
        }
        return instance
    }
    
    func googleLogin() {
        guard let vc = self.getHiehestViewController() else {
            return
        }
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) {[weak self] result, error in
            guard error == nil else {
                print("error",error ?? "")
                return
            }
            self?.signInResult = result
            self?.additionalScope(vc: vc)
        }
    }
    
    private func additionalScope(vc: UIViewController) {
        if let googleInstance = signInResult {
            let driveScope = scopeURLString
            let grantedScopes = googleInstance.user.grantedScopes
            if grantedScopes == nil || !grantedScopes!.contains(driveScope) {
                self.refreshCheck()
            }
            let additionalScopes = [scopeURLString]
            
            googleInstance.user.addScopes(additionalScopes, presenting: vc) {[weak self] signInResult, error in
                guard error == nil else {
                    return
                }
                guard let signInResult = signInResult else { return }
                self?.signInResult = signInResult
            }
        }
    }
    
    func refreshCheck() {
        if let googleInstance = self.signInResult {
            googleInstance.user.refreshTokensIfNeeded { user, error in
                guard error == nil else { return }
                guard let user = user else { return }
                let accessToken = user.accessToken.tokenString
                let authorizer = googleInstance.user.fetcherAuthorizer
                print("check ",googleInstance.user.accessToken.tokenString, accessToken,authorizer)
            }
        }
    }
}
