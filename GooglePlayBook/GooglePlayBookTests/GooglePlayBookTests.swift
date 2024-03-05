//
//  GooglePlayBookTests.swift
//  GooglePlayBookTests
//
//  Created by JeongHyun Kim on 2/29/24.
//

import XCTest
@testable import GooglePlayBook

final class GooglePlayBookTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRegularExpression() throws {
        let text = "세상에서 가장 위험한 </p><p>  </p><p>소설?! 걸리버 여행기(Gul</p><p>  </p><p>liver's Travels into </p><p>  </p><p>Several Remote Nations of the World)(1726)"
        let pattern = "<[^>]+>"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: text.utf16.count)
        let testString = regex?.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "") ?? ""
        
        XCTAssertEqual(testString, "세상에서 가장 위험한   소설?! 걸리버 여행기(Gul  liver's Travels into   Several Remote Nations of the World)(1726)")
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
