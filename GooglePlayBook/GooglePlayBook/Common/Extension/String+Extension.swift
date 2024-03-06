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
        let sizeInPixels = CGSize(width: size.width , height: size.height )
        
        return sizeInPixels
    }
    
    static func ratingValue(rating: Double) -> String {
        switch rating {
        case 0..<1:
            return "☆☆☆☆☆"
        case 1..<2:
            return "★☆☆☆☆"
        case 2..<3:
            return "★★☆☆☆"
        case 3..<4:
            return "★★★☆☆"
        case 4..<5:
            return "★★★★☆"
        default:
            return "★★★★★"
        }
    }
}
