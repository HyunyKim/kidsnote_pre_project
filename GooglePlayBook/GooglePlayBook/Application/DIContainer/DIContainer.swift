//
//  DIContainer.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/2/24.
//

import Foundation
import Swinject

final class DIContainer {
    static let shared = DIContainer()
    private let container: Container
    private init () {
        self.container = Container()
    }
    
    func defaultContainer() {
        
        self.container.register(NetworkService.self) { _ in
            DefaultNetworkService()
        }
        
        self.container.register(EBookItemsRepository.self) { resolver in
            DefaultEBookItemsRepository(networkService: resolver.resolve(NetworkService.self)!)
        }
        
        self.container.register(SearchEBooksUseCase.self) { resolver in
            DefaultSearchEBooksUseCase(ebookRepository: resolver.resolve(EBookItemsRepository.self)!)
        }
        
        self.container.register(SearchViewModel.self) { resolver in
            SearchViewModel()
        }
        
        self.container.register(BookInfoRepository.self) { resolver in
            DefaultBookInfoRepository(networkService: resolver.resolve(NetworkService.self)!)
        }
        
        self.container.register(BookInfoUseCase.self) { resolver in
            DefaultBookInfoUseCase(eBookRepository: resolver.resolve(BookInfoRepository.self)!)
        }
        
        self.container.register(BookViewModel.self) { resolver in
            BookViewModel()
        }
    }
    
    func regitst<T>(_ dependency: T) {
        container.register(T.self) { _ in
            dependency
        }
    }
    
    func resolve<T>() -> T {
        let resolbed = container.resolve(T.self)
        precondition(resolbed != nil,"No defendency For\(T.self)")
        return resolbed!
    }
}
