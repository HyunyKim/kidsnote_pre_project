//
//  Identifier.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/3/24.
//

import UIKit

protocol Identifier {
    static var identifier: String { get }
}

extension Identifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView: Identifier { }
