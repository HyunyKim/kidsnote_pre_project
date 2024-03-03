//
//  SearchResultViewModel.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/3/24.
//

import Foundation
import RxSwift
import RxCocoa

// TODO: - ReactorKit으로 가느냐 ViewModelType을 세분화 하느냐.....

final class SearchViewModel: ViewModelType {
    typealias SearchResult = Swift.Result<(items:[EBook],hasMore: Bool),Error>
    struct Input {
        var searchKeyword: Observable<String>
        var typingAction: Observable<String>
        var loadMoreAction: Observable<Void>
    }
    struct Output {
        var searchResult: Driver<SearchResult>
        var restValues: Observable<Void>
    }
    
    @Inject private var useCase: SearchEBookUseCase
    private var currentKeyword: String = ""
    private var totalItems: Int = 0
    private var ebookItems: [EBook] = []
    
    func transform(input: Input) -> Output {
        
        let reset = input.typingAction
            .do { [weak self] _ in
                self?.currentKeyword = ""
                self?.ebookItems.removeAll()
            }.flatMapLatest { _ -> Observable<Void> in
                return .just(())
            }
        
        let result = input.searchKeyword
            .do { [weak self] keyword in
                self?.currentKeyword = keyword
                self?.ebookItems.removeAll()
            }
            .flatMapLatest { [weak self] keyword -> Observable<EBooksContainer> in
                guard let self = self else { return .empty()}
                return self.searchRequest(keyword: keyword)
            }
            .do { [weak self] result in
                self?.totalItems = result.totalItems
                self?.ebookItems = result.items
            }.map { [weak self] _ in
                SearchResult.success((self?.ebookItems ?? [], (self?.ebookItems.count ?? 0) < (self?.totalItems ?? 0)))
            }
        
        let loadMoreResult = input.loadMoreAction
            .flatMapLatest { [weak self] _ -> Observable<EBooksContainer>  in
                guard let self = self else { return .empty()}
                return self.searchRequest(keyword: self.currentKeyword)
            }
            .do { [weak self] result in
                self?.totalItems = result.totalItems
                self?.ebookItems.append(contentsOf: result.items)
            }
            .map { [weak self] _ in
                SearchResult.success((self?.ebookItems ?? [], (self?.ebookItems.count ?? 0) < (self?.totalItems ?? 0)))
            }
        
        let total = Observable<SearchResult>
            .merge(result,loadMoreResult)
            .asDriver { error in
                    .just(.failure(error))
            }
        return Output(searchResult: total,restValues: reset)
    }
    
    private func searchRequest(keyword: String) -> Observable<EBooksContainer> {
        return Observable<EBooksContainer>.create { [weak self] observer in
            guard let self = self else {
                //TODO: - 컴플리트 할지 말지 고민
                observer.onCompleted()
                return Disposables.create()
            }
            let query = SearchQuery(q: keyword, maxResults: 20, startIndex: self.ebookItems.count)
            let cancelable = self.useCase.requestItems(query: query) { result in
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
