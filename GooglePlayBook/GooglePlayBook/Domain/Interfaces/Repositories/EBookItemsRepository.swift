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
        completion: @escaping DefaultCompleteHandler<EBooksContainer>
    ) -> Cancellable?
}
