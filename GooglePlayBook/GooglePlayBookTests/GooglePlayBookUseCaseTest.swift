//
//  GooglePlayBookUseCaseTest.swift
//  GooglePlayBookTests
//
//  Created by JeongHyun Kim on 3/2/24.
//

import XCTest
@testable import GooglePlayBook

final class GooglePlayBookUseCaseTest: XCTestCase {
    let repository = DefaultEBookRepository()
    var useCase: SearchEBookUseCase!
    var query: SearchQuery!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.useCase = DefaultSearchEBookUseCase(ebookRepository: repository)
        self.query = SearchQuery(q: "Swift",maxResults: 2)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

    }

    func testSearchUseCase() throws {
        let expectation = XCTestExpectation(description: "PlayBookUsecaseTest")
        var ebookContainer: EBooksContainer? = nil
        useCase.requestItems(query: query) { result in
            switch result {
            case .success(let success):
                ebookContainer = success
            case .failure(let failure):
                XCTAssertFalse(true,"실패해서는 안된다(추후에 오프라인테스트 추가")
                print(failure.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 30)
        XCTAssertNotNil(ebookContainer,"통신성공후 nil이면 안된다")
        guard let item = ebookContainer?.items.first else {
            XCTAssertFalse(true,"item이 존재해야한다")
            return
        }
        XCTAssertEqual(item.title, "스위프트 프로그래밍: Swift 5(3판)","바뀔 수 있기 때문에 offline 테스트 필요")
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
