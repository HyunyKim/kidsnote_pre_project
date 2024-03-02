//
//  SearchEBookUseCase.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation

protocol SearchEBookUseCase {
    typealias SearchComplteHandler = (Swift.Result<EBooksContainer, Error>) -> Void
    @discardableResult
    func requestItems(
        query: SearchQuery,
        completion: @escaping(Swift.Result<EBooksContainer, Error>) -> Void
    ) -> Cancellable?
}

struct DefaultSearchEBookUseCase {
    private let ebookRepository: EBookRepository
    
    init(ebookRepository: EBookRepository) {
        self.ebookRepository = ebookRepository
    }
}

extension DefaultSearchEBookUseCase: SearchEBookUseCase {
    @discardableResult
    func requestItems(query: SearchQuery, completion: @escaping (Result<EBooksContainer, Error>) -> Void) -> Cancellable? {
        ebookRepository.fetchEBookItems(parameter:query,         completion: completion)
    }
    
    
}
