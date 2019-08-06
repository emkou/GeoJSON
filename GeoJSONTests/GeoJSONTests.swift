//
//  GeoJSONTests.swift
//  GeoJSONTests
//
//  Created by Emil Doychinov on 5/29/19.
//  Copyright © 2019 Emil Doychinov. All rights reserved.
//

import XCTest
@testable import GeoJSON

class GeoJSONTests: XCTestCase {

    override func setUp() {
        
    }

    override func tearDown() {
        
    }

    func testSuccessResponseWithGeoFactory() {
     
        let ex = expectation(description: "Expecting posts generated")
        let request = GeometryFactory(request: MockSuccessRequest())
        request.request(with: routes.areasInRadius(latitude: 0, longitude: 0), success: { (collection) in
            print(collection)
            XCTAssertEqual(collection.features.count, 2)
             ex.fulfill()
        }) { (code) in
            XCTFail("error")
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
    
    
//    func testSuccessResponseWithGeoFeeeactory() {
//
//        let session = URLSessionMock()
//        session.data = nil
//        session.error = nil
//        let ex = expectation(description: "Expecting posts generated")
//        let req = Request(with: session)
//        req.request(url: "", method: .get, success: { (response) in
//            XCTFail("error")
//        }) { (code) in
//            XCTAssertNil(code)
//        }
//
//        waitForExpectations(timeout: 10) { error in
//            if let error = error {
//                XCTFail("error: \(error)")
//            }
//        }
//    }

}

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    // Properties that enable us to set exactly what data or error
    // we want our mocked URLSession to return for any request.
    var data: Data?
    var error: Error?
    override func dataTask(
        with url: URL,
        completionHandler: @escaping CompletionHandler
        ) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }
    }
}
