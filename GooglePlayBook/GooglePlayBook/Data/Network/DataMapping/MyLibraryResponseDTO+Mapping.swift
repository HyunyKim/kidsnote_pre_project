//
//  MyLibraryResponseDTO+Mapping.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/6/24.
//

import Foundation

struct MyLibraryResponseDTO: Decodable {
    let kind: String
    let items: [BookshelfDTO]
    

}
extension MyLibraryResponseDTO {
    func toDomain() -> MyLibrary {
        return MyLibrary(kind: kind, items: items.map({$0.toDomain()}))
    }
}
struct BookshelfDTO: Decodable {
    let kind: String
    let id: Int
    let title: String
    let access: String
    let updated: String
    let created: String
    let volumeCount: Int
    let volumesLastUpdated: String
}



extension BookshelfDTO {
    func toDomain() -> Bookshelf {
        return .init(id: Bookshelf.Identifier(id), title: title, volumeCount: volumeCount)
    }
}
