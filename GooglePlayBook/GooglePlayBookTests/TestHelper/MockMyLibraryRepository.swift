//
//  MockMyLibraryRepository.swift
//  GooglePlayBookTests
//
//  Created by JeongHyun Kim on 3/7/24.
//

import Foundation
@testable import GooglePlayBook

struct MockMyLibraryRepository {
    
}

extension MockMyLibraryRepository: MyLibraryRepository, ReadJsonParsing {
    func fetchMylibrary(key: String, completion: @escaping GooglePlayBook.DefaultCompleteHandler<GooglePlayBook.MyLibrary>) -> GooglePlayBook.Cancellable? {
        readJsonNCompletion(fileName: "MylibraryList") { (result: (Swift.Result<GooglePlayBook.MyLibraryResponseDTO,Error>)) in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return nil
    }
    
    func fetchShelfList(key: String, shelfId: Int, completion: @escaping GooglePlayBook.DefaultCompleteHandler<GooglePlayBook.EBooksContainer>) -> GooglePlayBook.Cancellable? {
        readJsonNCompletion(fileName: "Searchvolumes") { (result: (Swift.Result<GooglePlayBook.EBooksResponseDTO,Error>)) in
            switch result {
            case .success(let responsDTO):
                completion(.success(responsDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return nil
    }
    
    func registerToMyShelf(key: String, shelfId: Int, volumeId: String, completion: @escaping GooglePlayBook.DefaultCompleteHandler<GooglePlayBook.EmptyResult>) -> GooglePlayBook.Cancellable? {
            completion(.success(EmptyResult()))
        return nil
    }
    
    
}
