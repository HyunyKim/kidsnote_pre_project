//
//  DefaultEBookRepository.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation
import LevelOSLog

struct DefaultEBookItemsRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }
}

extension DefaultEBookItemsRepository: EBookItemsRepository {
    
    func fetchEBookItems(
        parameter: SearchQuery,
        completion: @escaping DefaultCompleteHandler<EBooksContainer>) -> Cancellable? {
            let itemsRequestDTO = EbookItemsRequestDTO(q: parameter.q,
                                                  filter: parameter.filter?.rawValue,
                                                  langRestrict: parameter.langRestrict,
                                                  maxResults: parameter.maxResults,
                                                  orderBy: parameter.orderBy?.rawValue,
                                                  printType: parameter.printType?.rawValue,
                                                  projection: parameter.projection?.rawValue,
                                                  startIndex: parameter.startIndex,
                                                  specialKeyword: parameter.specialKeyword?.rawValue
                                                    )
            return networkService.request(endpoint: GoogleBooks.SearchAPI.getItems(with: itemsRequestDTO)) { (result: Swift.Result<EBooksResponseDTO, NetworkError>) in
                switch result {
                case .success(let responseDTO):
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
