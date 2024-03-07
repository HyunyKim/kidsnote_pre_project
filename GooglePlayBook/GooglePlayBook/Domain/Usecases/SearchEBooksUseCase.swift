//
//  SearchEBookUseCase.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation

typealias DefaultCompleteHandler<T> = (Swift.Result<T,Error>) -> Void

protocol SearchEBooksUseCase {
    @discardableResult
    func requestItems(
        query: SearchQuery,
        completion: @escaping DefaultCompleteHandler<EBooksContainer>
    ) -> Cancellable?
}

struct DefaultSearchEBooksUseCase {
    
    private let eBookItemsRepository: EBookItemsRepository
    init(ebookRepository: EBookItemsRepository) {
        self.eBookItemsRepository = ebookRepository
    }
}

extension DefaultSearchEBooksUseCase: SearchEBooksUseCase {
    
    @discardableResult
    func requestItems(
        query: SearchQuery,
        completion: @escaping DefaultCompleteHandler<EBooksContainer>) -> Cancellable? {
        eBookItemsRepository.fetchEBookItems(parameter:query, completion: completion)
    }
}
