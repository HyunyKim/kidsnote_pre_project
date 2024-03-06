//
//  UILabel+Extension.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/5/24.
//

import Foundation
import UIKit


extension UILabel {
    func titleUI(font: UIFont = UIFont.systemFont(ofSize: 20, weight: .medium),
                textColor: UIColor = .textColor1,
                breakMode: NSLineBreakMode = .byWordWrapping,
                lineNumber: Int = 1,
                alignment: NSTextAlignment = .left) {
        
        make(font: font, textColor: textColor, breakMode: breakMode, lineNumber: lineNumber,alignment: alignment)
    }
    
    func descriptionUI(font: UIFont = UIFont.systemFont(ofSize: 12, weight: .regular),
                       textColor: UIColor = .eGray,
                       breakMode: NSLineBreakMode = .byWordWrapping,
                       lineNumber: Int = 1,
                       alignment: NSTextAlignment = .left) {
        
        make(font: font, textColor: textColor, breakMode: breakMode, lineNumber: lineNumber,alignment: alignment)
    }
    
    func listTitleUI(font: UIFont = UIFont.systemFont(ofSize: 13,weight: .regular),
                     textColor: UIColor = .textColor1,
                     breakMode: NSLineBreakMode = .byTruncatingTail,
                     lineNumber: Int = 2,
                     alignment: NSTextAlignment = .left) {
        
        make(font: font, textColor: textColor, breakMode: breakMode, lineNumber: lineNumber,alignment: alignment)
    }
    
    func listDesrciptionUI(font: UIFont = UIFont.systemFont(ofSize: 11,weight: .light),
                           textColor: UIColor = .gray,
                           breakMode: NSLineBreakMode = .byTruncatingTail,
                           lineNumber: Int = 1,
                           alignment: NSTextAlignment = .left) {
        
        make(font: font, textColor: textColor, breakMode: breakMode, lineNumber: lineNumber, alignment: alignment)
    }
    
    private func make(font: UIFont, textColor: UIColor, breakMode: NSLineBreakMode, lineNumber: Int, alignment: NSTextAlignment = .left) {
        self.font = font
        self.textColor = textColor
        self.lineBreakMode = breakMode
        self.numberOfLines = lineNumber
        self.textAlignment = alignment
    }
    
    func htmlStringSet(text: String) {
        if let htmlData = text.data(using: .unicode) {
            do {
                let attributedString = try NSMutableAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                let range = NSRange(location: 0, length: attributedString.length)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 5
                attributedString.addAttributes([.paragraphStyle: paragraphStyle, .foregroundColor: UIColor.textColor1], range: range)
                self.attributedText = attributedString
            } catch {
                self.text = text
            }
        }
    }
}
