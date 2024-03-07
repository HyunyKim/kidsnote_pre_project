//
//  VolumeInfo.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/4/24.
//

import Foundation

extension GoogleBooks.VolumeInfo {
    
    static func getBookInfo(bookId: String, with requestDTO: BookInfoRequestDTO?) -> EndPoint<EBooksResponseDTO.EBookDTO> {
        return EndPoint(
            baseURL: GoogleBooks.baseUrl,
            path: "volumes/\(bookId)",
            method: .get,
            queryParametersEncodable: requestDTO )
    }
}
