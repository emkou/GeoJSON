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
    func request(url: String, method: method, success: @escaping (Response?) -> Void, failure: @escaping (Response?) -> Void) {
        let path = Bundle.main.path(forResource: "success", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        success(Response(data: data, statusCode: 200))
    }
}


class MockSuccessRequestWithIncompatibleModel: RequestProtocol {
    func request(url: String, method: method, success: @escaping (Response?) -> Void, failure: @escaping (Response?) -> Void) {
        let path = Bundle.main.path(forResource: "success-nomodel", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        success(Response(data: data, statusCode: 200))
    }
}

class MockFailure: RequestProtocol {
    func request(url: String, method: method, success: @escaping (Response?) -> Void, failure: @escaping (Response?) -> Void) {
        failure(Response(data: nil, statusCode: 400))
    }
}
