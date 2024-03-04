//
//  EBook.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 2/29/24.
//

import Foundation

struct EBook: Equatable,Identifiable {
    typealias Identifier = String
    
    let id: Identifier
    let title: String?
    let authors: [String]?
    let thumbNail: String?
    let isEBook: Bool?
}

struct EBooksContainer: Equatable {
    let totalItems: Int
    let kind: String
    let items: [EBook]
    
}
