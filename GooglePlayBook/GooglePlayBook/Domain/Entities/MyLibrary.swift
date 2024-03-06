//
//  MyLibrary.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/6/24.
//

import Foundation

struct Bookshelf: Equatable, Identifier {
    typealias Identifier = Int
    
    let id: Identifier
    let title: String?
    let volumeCount: Int?
}

struct MyLibrary: Equatable {
    let kind: String
    let items: [Bookshelf]
}
