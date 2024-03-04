//
//  BookDetailInfo.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/4/24.
//

import Foundation

struct BookDetailInfo: Equatable, Identifier {
    typealias Identifier = String
    
    let id             :Identifier
    let thumbNail      :String?
    let title          :String?
    let authors        :[String]?
    let isEBook        :Bool?
    let pageCount      :Int?
    
    let pdfURL         :String?
    let webReaerLink   :String?
    
    let description    :String?
    let publisher      :String?
    let publishedDate  :String?
    
    let selfLink       :String?
}
