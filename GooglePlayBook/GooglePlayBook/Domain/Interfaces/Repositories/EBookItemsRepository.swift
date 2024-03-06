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
    
    func fetchMylibrary(key: String, completion: @escaping DefaultCompleteHandler<MyLibrary>) -> Cancellable?
    
    func fetchShelfList(key: String, shelfId:Int, completion: @escaping DefaultCompleteHandler<EBooksContainer>) -> Cancellable?
}
