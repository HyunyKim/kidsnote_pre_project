//
//  BookshelfViewModel.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BookshelfViewModel: ViewModelType {
    typealias ShelfListResult = Swift.Result<[EBook],Error>
    struct Input {
        let getShelfAction: Observable<(key: String, shelfId: Int)>
    }
    
    struct Output {
        let volumeList: Driver<ShelfListResult>
    }
    
    private var useCase: MyLibraryUseCase
    private var bookList: [EBook] = []
    init(useCase: MyLibraryUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let list = input.getShelfAction
            .flatMapLatest { [weak self] (key, shelfId) -> Observable<EBooksContainer> in
                guard let self = self else { return .empty() }
                return self.searchRequest(key: key, shelfId: shelfId)
            }
            .do { [weak self] continer in
                self?.bookList = continer.items
            } .map { [weak self] _ in
                ShelfListResult.success(self?.bookList ?? [])
            }
        
        return Output(volumeList: list.asDriver(onErrorRecover: { error in
                .just(.failure(error))
        }))
    }
    
    private func searchRequest(key: String, shelfId: Int) -> Observable<EBooksContainer> {
        return Observable<EBooksContainer>.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let cancelable = self.useCase.requestShelfList(key: key, shelfId: shelfId) { result in
                switch result {
                case .success(let container):
                    observer.onNext(container)
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create {
                cancelable?.cancel()
            }
        }
    }
}
