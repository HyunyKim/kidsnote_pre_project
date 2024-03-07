//
//  DefaultMyLibraryRepository.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/7/24.
//

import Foundation

struct DefaultMyLibraryRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultMyLibraryRepository: MyLibraryRepository {
    func fetchMylibrary(key: String,
                        completion: @escaping (Result<MyLibrary, Error>) -> Void) -> Cancellable? {
        return networkService.request(
            endpoint: GoogleBooks.SearchAPI.getMylibraryList(key: key)
        ) { (result: Swift.Result<MyLibraryResponseDTO, NetworkError>) in
            
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
                
            case .failure(let error):
                print("error",error)
            }
        }
    }
    
    func fetchShelfList(key: String,
                        shelfId:Int,
                        completion: @escaping DefaultCompleteHandler<EBooksContainer>) -> Cancellable? {
        return networkService.request(
            endpoint: GoogleBooks.SearchAPI.getShelfList(key: key, shelfId: shelfId)
        ) { (result: Swift.Result<EBooksResponseDTO, NetworkError>) in
            
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func registerToMyShelf(key: String,
                           shelfId: Int,
                           volumeId: String,
                           completion: @escaping DefaultCompleteHandler<EmptyResult>) -> Cancellable? {
        let registDTO = RegisterToMyShelfRequestDTO(volumeId: volumeId)
        
        return networkService.request(
            endpoint: GoogleBooks.SearchAPI.addMyShelfList(key: key, shelfId: shelfId, requestDTO: registDTO)
        ) { (result: Swift.Result<EmptyResult, NetworkError>) in
            
            switch result {
            case .success(let emptyValue):
                completion(.success(emptyValue))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
