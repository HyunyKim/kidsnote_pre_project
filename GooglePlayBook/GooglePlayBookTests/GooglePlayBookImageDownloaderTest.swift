//
//  GooglePlayBookImageDownloaderTest.swift
//  GooglePlayBookTests
//
//  Created by JeongHyun Kim on 3/3/24.
//

import XCTest
@testable import GooglePlayBook

final class GooglePlayBookImageDownloaderTest: XCTestCase {

    let urlString1 = "http://books.google.com/books/content?id=0HJXEAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"
    let urlStirng2 = "http://books.google.com/books/content?id=PeRFEAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"
    let bedURL = "http://aserweddeqwe?id=kidnote&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"
    let imageView = UIImageView()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testImageDownloader() throws {
        let expectation = XCTestExpectation(description: "ImageDownloadTest")
        var downData: Data?
        ImageDownloader.shared.downloadImage(urlString: urlString1) { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data,"이미지 데이터를 제대로 다운 받아야 한다")
                downData = data
            case .failure(let error):
                XCTAssertFalse(true,error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation],timeout: 10)
        
        guard let imageData = downData, let image = UIImage(data: imageData) else {
            XCTAssertFalse(true,"변환할 수 있는 데이터를 다운 받아야한다")
            return
        }
        imageView.image = image
    }
    
    func testBedURL() throws {
        let expectation = XCTestExpectation(description: "ImageDownloadTest")
        ImageDownloader.shared.downloadImage(urlString: bedURL) { result in
            switch result {
            case .success(let data):
                data == nil ? XCTAssertFalse(true,"에러로직이 동작해야한다.") : XCTAssertFalse(true,"에러로직이 동작해야한다.\(String(data: data!, encoding: .utf8) ?? "알수없는 데이터" ) ")
            case .failure(let error):
                print("error - \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation],timeout: 10)
    }
    
    func testImageCache() throws {
        let contentKey = "googlePlayBook"
        let image = UIImage(resource: .playbook)
        UIImageMemoryCache.shared.add(with: "googlePlayBook", content: image)
        
        XCTAssertNotNil(UIImageMemoryCache.shared.content(for: contentKey), "방금 저장한 이미지는 존재 해야 한다.")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
