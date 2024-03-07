//
//  BookViewModel.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BookViewModel: ViewModelType {
    typealias BookInfoResult = Swift.Result<BookDetailInfo,Error>
    struct Input {
        let loadInfoAction: Observable<String>
        let addMyShelfAction: Observable<(key: String,shelfId: Int,volumeId:String)>
    }
    
    struct Output {
        let bookInfo: Driver<BookInfoResult>
        let addResult: Observable<Void>
    }
    
    private var useCase     : BookInfoUseCase
    private var shelfUsecase: MyLibraryUseCase
    private var bookId: String?
    private var bookInfo: BookDetailInfo?
    
    init(useCase: BookInfoUseCase, shelfUsecase: MyLibraryUseCase, bookId: String? = nil, bookInfo: BookDetailInfo? = nil) {
        self.useCase = useCase
        self.shelfUsecase = shelfUsecase
        self.bookId = bookId
        self.bookInfo = bookInfo
    }
    
    func transform(input: Input) -> Output {
        let result = input.loadInfoAction
            .do { [weak self] bookId in
                self?.bookId = bookId
            }
            .flatMapLatest { [weak self] bookId -> Observable<BookDetailInfo> in
                guard let self = self else { return .empty() }
                return self.bookInfoRequest(requestBookId: bookId)
            }
            .do { [weak self] bookInfo in
                self?.bookInfo = bookInfo
            }
            .map { bookInfo in
                BookInfoResult.success(bookInfo)
            }
        
        let addResult = input.addMyShelfAction
            .flatMapLatest { [weak self] (key: String, shelfId: Int, volumeId: String) -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.addMyShelf(key: key, shelfId: shelfId, volumeId: volumeId)
            }
        
        let driver = result.asDriver { error in
                .just(.failure(error))
        }
        return Output(bookInfo: driver,addResult: addResult)
    }
    
    private func bookInfoRequest(requestBookId: String) -> Observable<BookDetailInfo> {
        return Observable<BookDetailInfo>.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            let query = SearchQuery(q: "",projection: .full)
            let cancellable = self.useCase.requestBookInfo(bookId:requestBookId, query: query) { result in
                switch result {
                case .success(let ebook):
                    observer.onNext(ebook)
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create {
                cancellable?.cancel()
            }
        }
    }
    
    private func addMyShelf(key: String, shelfId: Int, volumeId: String) -> Observable<Void> {
        return Observable<Void>.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            let cancellable = self.shelfUsecase.addToMyShelf(key: key, shelfId: shelfId, volumeId: volumeId) { result in
                switch result {
                case .success(_):
                    observer.onNext(())
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create {
                cancellable?.cancel()
            }
        }
    }
}
