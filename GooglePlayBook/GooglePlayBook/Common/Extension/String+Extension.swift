//
//  String+Extension.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/3/24.
//

import UIKit

extension String {
    func sizeInPixels(attributes: [NSAttributedString.Key: Any] = [:]) -> CGSize {
        let size = (self as NSString).size(withAttributes: attributes)
        let scale = UIScreen.main.scale
        let sizeInPixels = CGSize(width: size.width , height: size.height )
        
        return sizeInPixels
    }
}
