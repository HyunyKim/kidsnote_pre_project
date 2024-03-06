//
//  GooglePlayBookDTOTest.swift
//  GooglePlayBookTests
//
//  Created by JeongHyun Kim on 3/1/24.
//

import XCTest
@testable import GooglePlayBook

final class GooglePlayBookDTOTest: XCTestCase {
    
    struct TestObject: ReadJsonParsing {
        func objectTest() -> EBooksResponseDTO? {
            readJsonObject(fileName: "Searchvolumes")
        }
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEBookResponseDTO() throws {
        guard let object = TestObject().objectTest() else {
            XCTFail("파일로부터 디코딩이 실패해서는 안된다")
            return
        }
        XCTAssertEqual(object.items?.count ?? 0, 2,"JsonFile에 결과는 2개여야한다")
        let ebookContainer = object.toDomain()
        XCTAssertEqual(ebookContainer.items.count, 2,"Transform된 결과도 2개여야한다")
        guard let ebook = ebookContainer.items.first else {
            XCTFail("Transform된 모델이 있어야 한다")
            return
        }
        XCTAssertEqual(ebook.title, "처음 배우는 스위프트","JSonFile - Object - Transform된 데이터는 같아야 한다.")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
