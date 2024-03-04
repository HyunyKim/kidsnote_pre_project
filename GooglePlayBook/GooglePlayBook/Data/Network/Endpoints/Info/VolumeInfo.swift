//
//  VolumeInfo.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/4/24.
//

import Foundation

struct VolumeInfo {
    static var baseUrl: String {
        "https://www.googleapis.com/books/v1"
    }
    
    static func getBookInfo(bookId: String, with requestDTO: BookInfoRequestDTO?) -> EndPoint<EBooksResponseDTO.EBookDTO> {
        return EndPoint(baseURL: VolumeInfo.baseUrl, path: "volumes/\(bookId)", method: .get, queryParametersEncodable: requestDTO)
    }
}
