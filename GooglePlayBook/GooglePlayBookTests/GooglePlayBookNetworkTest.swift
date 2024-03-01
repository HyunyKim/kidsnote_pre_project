//
//  GooglePlayBookNetworkTest.swift
//  GooglePlayBookTests
//
//  Created by JeongHyun Kim on 3/1/24.
//

import XCTest
@testable import GooglePlayBook

final class GooglePlayBookNetworkTest: XCTestCase {
//https://www.googleapis.com/books/v1/volumes?filter=ebooks&maxResults=2&langRestrict=ko&q=ios&startIndex=0
    
    struct DefaultNetworkService: NetworkService {
        
    }
    
    var testObject: EndPoint = EndPoint(baseURL: "https://www.googleapis.com/books/v1", path: "volumes", method: .get)
    var networkService: DefaultNetworkService = DefaultNetworkService()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testObject.query = [
            "filter" : "ebooks",
            "maxResults" : 2,
            "startIndex" : 0,
            "langRestrict" : "ko",
            "q":"ios"
        ]
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNetworkService() throws {
        
        let expectation = XCTestExpectation(description: "PlayBookTest")
        var responseObject: EBooksContainer?
        var _ = networkService.request(endpoint: testObject) {  (result : Result<EBooksResponseDTO,NetworkError>) in
            switch result {
            case .success(let success):
                XCTAssertEqual(success.items.isEmpty, false,"통신에 성공시 값이 있어야 한다.")
                responseObject = success.toDomain()
                print(success)
            case .failure(let error):
                XCTAssertFalse(true, "NetworServcie 실패 \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation],timeout: 30)
        guard let object = responseObject, let first = object.items.first else {
            XCTAssertFalse(true,"Transform Model이 생성되어야 한다.")
            return
        }
        XCTAssertEqual(first.title, "처음 배우는 스위프트","바뀔수도 있기 때문에 PostMan등으로 테스트가 필요합니다. 지금은 바로 테스트 진행시 해당 타이틀입니다.")
                               
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
