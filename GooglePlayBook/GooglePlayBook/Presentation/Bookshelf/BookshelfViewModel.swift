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
    typealias ShelfListResult = Swift.Result<(items:[EBook],hasMore: Bool),Error>
    struct Input {
        let getShelfAction: Observable<(key: String, shelfId: Int)>
        let loadMoreAction: Observable<Int>
    }
    
    struct Output {
        let volumeList: Driver<ShelfListResult>
    }
    
    private var useCase: MyLibraryUseCase
    private var bookList: [EBook] = []
    private var totalItems    : Int
    private var endOfPage: Bool = false
    private var shelfId: Int
    private var accessKey: String = ""
    init(useCase: MyLibraryUseCase) {
        self.useCase = useCase
        self.shelfId = -1
        self.totalItems = 0
    }
    
    func transform(input: Input) -> Output {
        
        let result = input.getShelfAction
            .do { [weak self] (key, shelfId) in
                self?.endOfPage = false
                self?.totalItems = 0
                self?.bookList.removeAll()
                self?.shelfId = shelfId
                self?.accessKey = key
            }
            .flatMapLatest { [weak self] (key, shelfId) -> Observable<EBooksContainer> in
                guard let self = self else { return .empty()}
                return self.searchRequest(key: key, shelfId: shelfId)
            }
            .do { [weak self] result in
                self?.totalItems = result.totalItems
                self?.bookList = result.items
            }.map { [weak self] _ in
                ShelfListResult.success((self?.bookList ?? [], (self?.endOfPage == true) ? false : (self?.bookList.count ?? 0) < (self?.totalItems ?? 0)))
            }
        
        let loadMoreResult = input.loadMoreAction
            .distinctUntilChanged()
            .flatMapLatest { [weak self] _ -> Observable<EBooksContainer>  in
                guard let self = self else { return .empty()}
                return self.searchRequest(key: self.accessKey, shelfId: self.shelfId)
            }
            .do { [weak self] result in
                self?.totalItems = result.totalItems
                self?.bookList.append(contentsOf: result.items)
            }
            .map { [weak self] _ in
                ShelfListResult.success((self?.bookList ?? [], (self?.endOfPage == true) ? false : (self?.bookList.count ?? 0) < (self?.totalItems ?? 0)))
            }
        
        let total = Observable<ShelfListResult>
            .merge(result,loadMoreResult)
            .asDriver { error in
                    .just(.failure(error))
            }
        
        return Output(volumeList: total.asDriver(onErrorRecover: { error in
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
                    self.endOfPage = !(container.items.count > 0)
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
