//
//   BookInfoUseCase.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/4/24.
//

import Foundation

protocol BookInfoUseCase {
    typealias GetBookInfoCompleteHandler = (Swift.Result<BookDetailInfo,Error>) -> Void
    func requestBookInfo(
        bookId: String,
        query: SearchQuery,
        completion: @escaping GetBookInfoCompleteHandler
    ) -> Cancellable?
}

struct DefaultBookInfoUseCase {
    
    private let eBookRepository: BookInfoRepository
    init(eBookRepository: BookInfoRepository) {
        self.eBookRepository = eBookRepository
    }
}

extension DefaultBookInfoUseCase: BookInfoUseCase {
    func requestBookInfo(
        bookId: String,
        query: SearchQuery,
        completion: @escaping GetBookInfoCompleteHandler) -> Cancellable? {
            eBookRepository.fetchBookInfo(bookId: bookId, parameter: query, completion: completion)
    }
}
