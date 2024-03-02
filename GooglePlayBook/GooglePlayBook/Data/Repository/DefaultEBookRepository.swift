//
//  DefaultEBookRepository.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation
import LevelOSLog

struct DefaultEBookRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultEBookRepository: EBookRepository {
    func fetchEBookItems(
        parameter: SearchQuery,
        completion: @escaping (Swift.Result<EBooksContainer, Error>) -> Void) -> Cancellable? {
            let ebookRequestDTO = EbookRequestDTO(q: parameter.q,
                                                  filter: parameter.filter?.rawValue,
                                                  langRestrict: parameter.langRestrict,
                                                  maxResults: parameter.maxResults,
                                                  orderBy: parameter.orderBy?.rawValue,
                                                  printType: parameter.printType?.rawValue,
                                                  projection: parameter.projection?.rawValue,
                                                  startIndex: parameter.startIndex,
                                                  specialKeyword: parameter.specialKeyword?.rawValue
                                                    )
            return networkService.request(endpoint: SearchAPI.getItems(with: ebookRequestDTO)) { (result: Swift.Result<EBooksResponseDTO,NetworkError>) in
                switch result {
                case .success(let responseDTO):
                    Log.network("Search Items", responseDTO)
                    Log.network("Search Items", responseDTO.toDomain())
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    Log.error("search itemsError", error.localizedDescription)
                    completion(.failure(error))
                }
            }
    }
    
    
}
