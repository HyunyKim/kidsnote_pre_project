//
//  Search.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/1/24.
//

import Foundation

struct SearchAPI {
    static var baseUrl: String {
        "https://www.googleapis.com/books/v1"
    }

    static func getItems(with requestDTO: EbookItemsRequestDTO) -> EndPoint<EBooksResponseDTO> {
        return EndPoint(baseURL: SearchAPI.baseUrl, path: "volumes", method: .get, queryParametersEncodable:requestDTO)
    }
}
