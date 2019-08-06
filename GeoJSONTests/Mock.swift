//
//  Mock.swift
//  GeoJSONTests
//
//  Created by Emil Doychinov on 7/4/19.
//  Copyright © 2019 Emil Doychinov. All rights reserved.
//


@testable import GeoJSON

class MockSuccessRequest: RequestProtocol {
    func request(url: String, method: method, success: @escaping (Response?) -> Void, failure: @escaping (Response?) -> Void) {
         success(Response(data: nil, statusCode: 200))
    }
}

class MockSuccessRequestWithNonDecodableObject: RequestProtocol {
    func request(url: String, method: method, success: @escaping (Response?) -> Void, failure: @escaping (Response?) -> Void) {
        success(Response(data: nil, statusCode: 200))
    }
}

class MockFailedRequest: RequestProtocol {
    func request(url: String, method: method, success: @escaping (Response?) -> Void, failure: @escaping (Response?) -> Void) {
        failure(Response(data: nil, statusCode: 400))
    }
}
