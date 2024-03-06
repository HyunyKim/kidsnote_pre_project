//
//  UIViewController+Extension.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/6/24.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert( title: String = "알림",
                    message: String,
                    buttonTitle: String = "확인",
                    button2Title: String? = nil,
                    completion: (() -> Void)? = nil,
                    button1Completion:((UIAlertAction) -> Void)? = nil,
                    button2Completion:((UIAlertAction) -> Void)? = nil ) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button1 = UIAlertAction(title: buttonTitle, style: .default,handler: button1Completion)
        alertController.addAction(button1)
        if let title2 = button2Title {
            let button2 = UIAlertAction(title: title2, style: .default,handler: button2Completion)
            alertController.addAction(button2)
        }
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: completion)
        }
    }
}
