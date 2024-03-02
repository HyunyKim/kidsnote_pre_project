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
    //TODO: - Naming을 path로 할지 동작으로 할지 생각이 필요함.
    static func getItems(with requestDTO: EbookRequestDTO) -> EndPoint<EBooksResponseDTO> {
        return EndPoint(baseURL: SearchAPI.baseUrl, path: "volumes", method: .get, queryParametersEncodable:requestDTO)
    }
}
