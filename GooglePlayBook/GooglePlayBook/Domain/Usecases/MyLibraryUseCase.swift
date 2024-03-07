//
//  MyLibraryUseCase.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/7/24.
//

import Foundation

protocol MyLibraryUseCase {
    func requestMylibrary(
        key: String,
        completion: @escaping DefaultCompleteHandler<MyLibrary>
    ) -> Cancellable?
    
    func requestShelfList(
        key: String,
        shelfId: Int,
        completion: @escaping DefaultCompleteHandler<EBooksContainer>
    ) -> Cancellable?
    
    func addToMyShelf                       (
        key: String,
        shelfId: Int,
        volumeId: String,
        completion: @escaping DefaultCompleteHandler<EmptyResult>
    ) -> Cancellable?
}

struct DefaultMyLibraryUseCase {
    private let myLibraryRepository: MyLibraryRepository
    init(myLibraryRepository: MyLibraryRepository) {
        self.myLibraryRepository = myLibraryRepository
    }
}

extension DefaultMyLibraryUseCase: MyLibraryUseCase {
    func requestMylibrary(key: String,
                          completion: @escaping DefaultCompleteHandler<MyLibrary>) -> Cancellable? {
        myLibraryRepository.fetchMylibrary(key: key, completion: completion)
    }
    
    func requestShelfList(key: String,
                          shelfId: Int,
                          completion: @escaping DefaultCompleteHandler<EBooksContainer>) -> Cancellable?{
        myLibraryRepository.fetchShelfList(key: key, shelfId: shelfId, completion: completion)
    }
    
    func addToMyShelf(key: String,
                      shelfId: Int,
                      volumeId: String,
                      completion: @escaping DefaultCompleteHandler<EmptyResult>) -> Cancellable? {
        myLibraryRepository.registerToMyShelf(key: key, shelfId: shelfId, volumeId: volumeId, completion: completion)
    }
}
