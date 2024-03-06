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
    
    static func getMylibrary(key: String) -> EndPoint<EBooksResponseDTO> {
        var endpoint = EndPoint<EBooksResponseDTO>(baseURL: SearchAPI.baseUrl, path: "mylibrary/bookshelves/2/volumes", method: .get)
        var header = ["Content-Type" : "application/json"]
        header["Accept"] = "application/json"
        header["Authorization"] = "Bearer \(key)"
        endpoint.headerParamerter = header
        return endpoint
    }
    
    static func getMylibraryList(key: String) -> EndPoint<MyLibraryResponseDTO> {
        var endpoint = EndPoint<MyLibraryResponseDTO>(baseURL: SearchAPI.baseUrl, path: "mylibrary/bookshelves", method: .get)
        var header = ["Content-Type" : "application/json"]
        header["Accept"] = "application/json"
        header["Authorization"] = "Bearer \(key)"
        endpoint.headerParamerter = header
        return endpoint
    }
}
