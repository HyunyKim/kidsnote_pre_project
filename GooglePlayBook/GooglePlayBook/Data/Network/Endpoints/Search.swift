//
//  Search.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/1/24.
//

import Foundation

extension GoogleBooks.SearchAPI {
    static func getItems(with requestDTO: EbookItemsRequestDTO) -> EndPoint<EBooksResponseDTO> {
        return EndPoint(
            baseURL: GoogleBooks.baseUrl,
            path: "volumes",
            method: .get,
            queryParametersEncodable:requestDTO )
    }
        
    static func getMylibraryList(key: String) -> EndPoint<MyLibraryResponseDTO> {
        var endpoint = EndPoint<MyLibraryResponseDTO>(
            baseURL: GoogleBooks.baseUrl,
            path: "mylibrary/bookshelves",
            method: .get,
            query: ["key": GoogleManager.share.apiKey])
        
        endpoint.headerParamerter = ["Authorization" : "Bearer \(key)"]
        return endpoint
    }
    
    static func getShelfList(key: String, shelfId: Int, startIndex: Int) -> EndPoint<EBooksResponseDTO> {
        var endpoint = EndPoint<EBooksResponseDTO>(
            baseURL: GoogleBooks.baseUrl,
            path: "mylibrary/bookshelves/\(shelfId)/volumes",
            method: .get,
            query: ["key": GoogleManager.share.apiKey,"startIndex":startIndex] )
        
        endpoint.headerParamerter = ["Authorization" : "Bearer \(key)"]
        return endpoint
    }
    
    static func addMyShelfList(key: String, shelfId: Int, requestDTO: RegisterToMyShelfRequestDTO) -> EndPoint<EmptyResult> {
        var endpoint = EndPoint<EmptyResult>(
            baseURL: GoogleBooks.baseUrl,
            path: "mylibrary/bookshelves/\(shelfId)/addVolume",
            method: .post,
            query: ["key": GoogleManager.share.apiKey],
            bodyParametersEncodable: requestDTO )
        
        endpoint.headerParamerter = ["Authorization" : "Bearer \(key)"]
        return endpoint
    }
}

