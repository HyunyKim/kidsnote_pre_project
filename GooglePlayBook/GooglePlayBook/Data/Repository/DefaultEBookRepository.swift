//
//  DefaultEBookRepository.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation

struct DefaultEBookRepository {
    
}

extension DefaultEBookRepository: EBookRepository {
    func fetchEBookItems(complition: @escaping (Result<EBooksContainer, Error>) -> Void) -> Cancellable? {
        return nil
    }
    
    
}
