//
//  DefaultMockRepository.swift
//  GooglePlayBookTests
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation
@testable import GooglePlayBook

struct MockEbookItemsRepository: EBookItemsRepository,ReadJsonParsing {
    func fetchMylibrary(key: String, completion: @escaping GooglePlayBook.DefaultCompleteHandler<GooglePlayBook.MyLibrary>) -> GooglePlayBook.Cancellable? {
        return nil
    }
    
    func fetchShelfList(key: String, shelfId: Int, completion: @escaping GooglePlayBook.DefaultCompleteHandler<GooglePlayBook.EBooksContainer>) -> GooglePlayBook.Cancellable? {
        return nil
    }
    
    func fetchEBookItems(parameter: GooglePlayBook.SearchQuery, completion: @escaping GooglePlayBook.DefaultCompleteHandler<GooglePlayBook.EBooksContainer>) -> GooglePlayBook.Cancellable? {
        readJsonNCompletion(fileName: "Searchvolumes") { (result: (Swift.Result<EBooksResponseDTO,Error>)) in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return nil
    }
}

struct MockBookInfoRepository: BookInfoRepository, ReadJsonParsing {
    func fetchBookInfo(bookId: String, parameter: SearchQuery, completion: @escaping (Result<BookDetailInfo, Error>) -> Void) -> Cancellable? {
        readJsonNCompletion(fileName: "VolumDetail") { (result: (Swift.Result<EBooksResponseDTO.EBookDTO,Error>)) in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return nil
    }
}
