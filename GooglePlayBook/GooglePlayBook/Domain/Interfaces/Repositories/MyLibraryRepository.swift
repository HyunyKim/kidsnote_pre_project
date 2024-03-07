//
//  MyLibraryRepository.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/7/24.
//

import Foundation

protocol MyLibraryRepository {
    
    func fetchMylibrary(
        key: String,
        completion: @escaping DefaultCompleteHandler<MyLibrary>
    ) -> Cancellable?
    
    func fetchShelfList(
        key: String,
        shelfId: Int,
        completion: @escaping DefaultCompleteHandler<EBooksContainer>
    ) -> Cancellable?
    
    func registerToMyShelf(
        key: String,
        shelfId: Int,
        volumeId: String,
        completion: @escaping DefaultCompleteHandler<EmptyResult>
    ) -> Cancellable?
}
