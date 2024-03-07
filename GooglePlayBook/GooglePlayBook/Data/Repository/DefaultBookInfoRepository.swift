//
//  DefaultEBookRepository.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/4/24.
//

import Foundation

struct DefaultBookInfoRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }
}

extension DefaultBookInfoRepository: BookInfoRepository {
    func fetchBookInfo(
        bookId: String,
        parameter: SearchQuery,
        completion: @escaping DefaultCompleteHandler<BookDetailInfo>) -> Cancellable? {
            let eBookInfoRequestDTO = BookInfoRequestDTO(projection: parameter.projection?.rawValue)
            return networkService.request(
                endpoint: GoogleBooks.VolumeInfo.getBookInfo(bookId: bookId,
                                                             with: eBookInfoRequestDTO)
            ) { (result: Swift.Result<EBooksResponseDTO.EBookDTO, NetworkError>) in
                switch result {
                case .success(let responseDTO):
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}
