//
//  GooglePlayBookUseCaseTest.swift
//  GooglePlayBookTests
//
//  Created by JeongHyun Kim on 3/2/24.
//

import XCTest
@testable import GooglePlayBook

final class GooglePlayBookUseCaseTest: XCTestCase {
    var useCase: SearchEBooksUseCase!
    var query: SearchQuery!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        DIContainer.shared.defaultContainer()
        DIContainer.shared.register(MockEbookItemsRepository() as EBookItemsRepository)
        DIContainer.shared.register(MockBookInfoRepository() as BookInfoRepository)
        DIContainer.shared.register(MockMyLibraryRepository() as MyLibraryRepository)
        self.useCase = DIContainer.shared.resolve()
        self.query = SearchQuery(q: "Swift",maxResults: 2)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

    }

    func testSearchUseCase() throws {
        let expectation = XCTestExpectation(description: "PlayBookUsecaseTest")
        var ebookContainer: EBooksContainer?
        useCase.requestItems(query: query) { result in
            switch result {
            case .success(let success):
                ebookContainer = success
            case .failure(let failure):
                XCTAssertFalse(true,"Mock데이터에서 실패해서는 안된다 \(failure.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(ebookContainer,"Mock -EBooksContainer 데이터를 읽어 오는데 실패해서는 안된다.")
        guard let item = ebookContainer?.items.first else {
            XCTAssertFalse(true,"item이 존재해야한다")
            return
        }
        XCTAssertEqual(item.title, "처음 배우는 스위프트","Json - Object - Transform에 데이터가 맞아야 한다.")
    }
    
    func testBookInfoUseCase() throws {
        @Inject var buseCase: BookInfoUseCase
        let expectaion = XCTestExpectation(description: "BookInfoUseCaseTest")
        var bookInfo: BookDetailInfo?
        buseCase.requestBookInfo(bookId: "abc", query: SearchQuery(q: "",projection: .full)) { result in
            switch result {
            case .success(let info):
                bookInfo = info
            case .failure(let error):
                XCTAssertFalse(true,"Mock데이터에서 실패해서는 안된다. \(error.localizedDescription)")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion],timeout: 10)
        XCTAssertNotNil(bookInfo, "Mock - BookDetailInfo 데이터를 읽어 오는데 실패해서는 안된다")
        guard let info = bookInfo else {
            XCTAssertFalse(true, "bookInfo가 존재해야 한다")
            return
        }
        XCTAssertEqual(info.title, "Swift Development with Cocoa", "Json - Object - Transform에 데이터가 맞아야 한다.")
    }
    
    func testMyLibraryUseCase() throws {
        @Inject var mLUsecase: MyLibraryUseCase
        let expectation = XCTestExpectation(description: "mylibraryTestCase")
        var myLibrary: MyLibrary?
        let _ = mLUsecase.requestMylibrary(key: "") { result in
            switch result {
            case .success(let library):
                XCTAssertNotNil(library, "Mock데이터")
                myLibrary = library
            case .failure(let error):
                XCTAssertFalse(true, "Mock데이터에서 실패해서는 안된다 \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation],timeout: 5)
        XCTAssertNotNil(myLibrary,"Mock데이 읽어온 값이 제대로 전달되어야 한다")
        XCTAssertEqual(myLibrary?.items.first?.title ?? "", "My Google eBooks","Json - Object - Transform에 데이터가 맞아야 한다.")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
