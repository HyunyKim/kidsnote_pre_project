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
        
        self.container.register(EBookRepository.self) { resolver in
            DefaultEBookRepository(networkService: resolver.resolve(NetworkService.self)!)
        }
        
        self.container.register(SearchEBookUseCase.self) { resolver in
            DefaultSearchEBookUseCase(ebookRepository: resolver.resolve(EBookRepository.self)!)
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
