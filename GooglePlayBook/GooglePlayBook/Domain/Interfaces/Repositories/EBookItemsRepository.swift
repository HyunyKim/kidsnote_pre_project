//
//  EBookRepository.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation

protocol EBookItemsRepository {
    func fetchEBookItems(
        parameter: SearchQuery,
        completion: @escaping(Swift.Result<EBooksContainer, Error>) -> Void
    ) -> Cancellable?
    
    func fetchMylibrary(key: String, completion: @escaping (Result<MyLibrary, Error>) -> Void) -> Cancellable?
}
