//
//  SearchEBookUseCase.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation

protocol SearchEBooksUseCase {
//TODO: - Error로 전달하는 값들이 제대로 나오는지 NetworkError와 확인해 봐야 한다.
    typealias SearchEBooksComplteHandler = (Swift.Result<EBooksContainer, Error>) -> Void
    @discardableResult
    func requestItems(
        query: SearchQuery,
        completion: @escaping SearchEBooksComplteHandler
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
        completion: @escaping SearchEBooksComplteHandler) -> Cancellable? {
        eBookItemsRepository.fetchEBookItems(parameter:query, completion: completion)
    }
    
    
}
