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
    }
    
    struct Output {
        let bookInfo: Driver<BookInfoResult>
    }
    
    @Inject private var useCase: BookInfoUseCase
    private var bookId: String?
    private var bookInfo: BookDetailInfo?
    
    
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
        let driver = result.asDriver { error in
                .just(.failure(error))
        }
        return Output(bookInfo: driver)
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
}
