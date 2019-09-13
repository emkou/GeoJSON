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

    func testSuccessResponseWithGeojsonObjects() {
     
        let ex = expectation(description: "Expecting posts generated")
        let request = GeometryFactory(request: MockSuccessRequest())
        request.request(with: routes.areasInRadius(latitude: 0, longitude: 0), success: { (collection) in
            print(collection)
            XCTAssertEqual(collection.features.count, 2)
             ex.fulfill()
        }) { (code) in
            XCTFail("error")
        }
        
        waitForExpectations(timeout: 2) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }

    func testSuccessResponseWithNoValidGeojsonObjects() {
        
        let ex = expectation(description: "Expecting no posts were generated")
        let request = GeometryFactory(request: MockSuccessRequestWithIncompatibleModel())
        request.request(with: routes.areasInRadius(latitude: 0, longitude: 0), success: { (collection) in
            XCTFail("error")
        }) { (code) in
            XCTAssertEqual(code, "Could not map geometry objects")
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 2) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
    
    func testFailedResponseShouldReturnRequestErrorString() {
        let ex = expectation(description: "Expecting return of error")
        let request = GeometryFactory(request: MockFailure())
        request.request(with: routes.areasInRadius(latitude: 0, longitude: 0), success: { (collection) in
            XCTFail("error")
        }) { (code) in
            XCTAssertEqual(code, "Request error")
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 2) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
    
    func testSuccessResponseWithRequestMaker() {
        let ex = expectation(description: "Expecting request was successful")
        let session = RequestSuccessMock()
        let req = Request(with: session)
        
        req.request(url: "", method: .get, success: { (data) in
            XCTAssertNotNil(data)
            ex.fulfill()
        }) { (_) in
            XCTFail("error")
        }

        waitForExpectations(timeout: 2) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
    
    func testFailedResponseWithRequestMaker() {
        let ex = expectation(description: "Expecting request failed")
        let session = RequestFailureMock()
        let req = Request(with: session)
        
        req.request(url: "", method: .get, success: { (data) in

            XCTFail("error")
        }) { (status) in
            XCTAssertEqual(status.description, "Server error")
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 2) { error in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
}
