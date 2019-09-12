//
//  Mock.swift
//  GeoJSONTests
//
//  Created by Emil Doychinov on 7/4/19.
//  Copyright © 2019 Emil Doychinov. All rights reserved.
//

import Foundation
import XCTest
@testable import GeoJSON

class MockSuccessRequest: RequestProtocol {
    func request(url: String, method: method, success: @escaping (Data) -> Void, failure: @escaping (HttpStatus) -> Void) {
        let path = Bundle.main.path(forResource: "success", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        success(data)
    }
}


class MockSuccessRequestWithIncompatibleModel: RequestProtocol {
    func request(url: String, method: method, success: @escaping (Data) -> Void, failure: @escaping (HttpStatus) -> Void) {
        let path = Bundle.main.path(forResource: "success-nomodel", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        success(data)
    }
}

class MockFailure: RequestProtocol {
    func request(url: String, method: method, success: @escaping (Data) -> Void, failure: @escaping (HttpStatus) -> Void) {
        failure(HttpStatus(with: 0))
    }
}
