//
//  SearchEBookUseCase.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation

protocol SearchEBookUseCase {
    typealias SearchComplteHandler = (Swift.Result<EBooksContainer, Error>) -> Void
    func requestItems(
        parameter: SearchQuery,
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
    func requestItems(parameter: SearchQuery, completion: @escaping (Result<EBooksContainer, Error>) -> Void) -> Cancellable? {
        ebookRepository.fetchEBookItems(complition: completion)
    }
    
    
}
