//
//  RequestMock.swift
//  GeoJSONTests
//
//  Created by Emil Doychinov on 9/12/19.
//  Copyright © 2019 Emil Doychinov. All rights reserved.
//

import Foundation
import XCTest
@testable import GeoJSON


class RequestSuccessMock: RequestSession {
    func request(with url: URL, result: @escaping (Result<(Data), HttpStatus>) -> Void) {
        result(.success(Data()))
    }
}


class RequestFailureMock: RequestSession {
    func request(with url: URL, result: @escaping (Result<(Data), HttpStatus>) -> Void) {
        result(.failure(HttpStatus(with: 500)))
    }
}
