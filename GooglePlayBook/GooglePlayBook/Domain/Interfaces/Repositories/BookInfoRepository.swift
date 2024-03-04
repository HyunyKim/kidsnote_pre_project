//
//  EBookInfoRepository.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/4/24.
//

import Foundation

protocol BookInfoRepository {
    func fetchBookInfo(
        bookId: String,
        parameter: SearchQuery,
        completion: @escaping(Swift.Result<BookDetailInfo, Error>)-> Void
    ) -> Cancellable?
}
