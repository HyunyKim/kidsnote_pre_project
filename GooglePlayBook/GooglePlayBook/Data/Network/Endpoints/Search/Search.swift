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
        
    static func getMylibraryList(key: String) -> EndPoint<MyLibraryResponseDTO> {
        var endpoint = EndPoint<MyLibraryResponseDTO>(baseURL: SearchAPI.baseUrl, path: "mylibrary/bookshelves", method: .get)
        var header = ["Content-Type" : "application/json"]
        header["Accept"] = "application/json"
        header["Authorization"] = "Bearer \(key)"
        endpoint.headerParamerter = header
        return endpoint
    }
    
    static func getShelfList(key: String, shelfId: Int) -> EndPoint<EBooksResponseDTO> {
        var endpoint = EndPoint<EBooksResponseDTO>(baseURL: SearchAPI.baseUrl, path: "mylibrary/bookshelves/\(shelfId)/volumes", method: .get ,query: ["key":"AIzaSyAnGsDsGGNhtKp9QJVPUYXA6ECiKBCzMU0"])
        var header = ["Content-Type" : "application/json"]
        header["Accept"] = "application/json"
        header["Authorization"] = "Bearer \(key)"
        endpoint.headerParamerter = header
        return endpoint
    }
}
