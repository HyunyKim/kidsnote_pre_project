//
//  SearchResultViewModel.swift
//  GooglePlayBook
//
//  Created by JeongHyun Kim on 3/3/24.
//

import Foundation
import RxSwift
import RxCocoa
import LevelOSLog

final class SearchViewModel: ViewModelType {
    typealias SearchResult = Swift.Result<(items:[EBook],hasMore: Bool),Error>
    typealias MyLibraryResult = Swift.Result<MyLibrary,Error>
    
    struct Input {
        var searchAction        : Observable<String>
        var typingAction        : Observable<String>
        var loadMoreAction      : Observable<Void>
        var searchMylibraryAction: Observable<String>
        var segmentAction       : Observable<Int>
    }
    
    struct Output {
        var searchResult    : Driver<SearchResult>
        var resetValue      : Observable<Void>
        var mylibraryResult : Driver<MyLibraryResult>
    }
    
    private var useCase       : SearchEBooksUseCase
    private var libraryuseCase: MyLibraryUseCase
    private var currentKeyword: String
    private var totalItems    : Int
    private var ebookItems    : [EBook]
    
    init(useCase: SearchEBooksUseCase, libraryuseCase: MyLibraryUseCase, currentKeyword: String = "", totalItems: Int = 0, ebookItems: [EBook] = []) {
        self.useCase        = useCase
        self.libraryuseCase = libraryuseCase
        self.currentKeyword = currentKeyword
        self.totalItems     = totalItems
        self.ebookItems     = ebookItems
    }
    
    var searchedKeyword: String {
        currentKeyword
    }
    
    func transform(input: Input) -> Output {
        
        let myLibrary = input.searchMylibraryAction
            .flatMapLatest { [weak self] key -> Observable<MyLibrary> in
                guard let self = self else {
                    return .empty()
                }
                return self.searchMyLibrary(oauthKey: key)
            }.map { library in
                MyLibraryResult.success(library)
            }
        
        let reset = input.typingAction
            .do { [weak self] _ in
                self?.currentKeyword = ""
                self?.ebookItems.removeAll()
            }.flatMapLatest { _ -> Observable<Void> in
                return .just(())
            }
        
        let result = input.searchAction
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
        let showEbook = input.segmentAction
            .map { [weak self] _ in
                SearchResult.success((self?.ebookItems ?? [], (self?.ebookItems.count ?? 0) < (self?.totalItems ?? 0)))
            }
        
        let total = Observable<SearchResult>
            .merge(result,loadMoreResult,showEbook)
            .asDriver { error in
                    .just(.failure(error))
            }
        return Output(searchResult: total,resetValue: reset, mylibraryResult: myLibrary.asDriver(onErrorRecover: { error in
                .just(.failure(error))
        }))
    }
    
    private func searchRequest(keyword: String) -> Observable<EBooksContainer> {
        return Observable<EBooksContainer>.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            let query = SearchQuery(q: keyword,
                                    filter: .ebooks,
                                    langRestrict: (Locale.current.language.languageCode?.identifier ?? "ko"),
                                    printType: .books,
                                    maxResults: 20,
                                    startIndex: self.ebookItems.count)
            let cancelable = self.useCase.requestItems(query: query) { result in
                switch result {
                case .success(let container):
                    observer.onNext(container)
                    Log.network("totalCount", container.totalItems)
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
    
    private func searchMyLibrary(oauthKey: String) -> Observable<MyLibrary> {
        return Observable<MyLibrary>.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            let cancelable = self.libraryuseCase.requestMylibrary(key: oauthKey) { result in
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
