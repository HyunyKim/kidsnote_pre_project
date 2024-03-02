//
//  EBookRepository.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation

protocol EBookRepository {
    func fetchEBookItems(
        parameter: SearchQuery,
        completion: @escaping(Swift.Result<EBooksContainer, Error>) -> Void
    ) -> Cancellable?
}
