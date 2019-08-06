//
//  Request.swift
//  GeoJSON
//
//  Created by Emil Doychinov on 5/30/19.
//  Copyright © 2019 Emil Doychinov. All rights reserved.
//

import Foundation

enum method {
    case get
}

protocol ResponseProtocol {
    var data: Data? { get }
    var statusCode: Int { get  }
}

struct Response: ResponseProtocol {
    let data: Data?
    let statusCode: Int
}

protocol RequestProtocol {
    func request(url: String, method: method, success: @escaping (Response?) -> Void, failure: @escaping (Response?) -> Void)
}

class Request: RequestProtocol {
    
    private let defaultSession: URLSession!
    private var dataTask: URLSessionDataTask?
    
    init(with session: URLSession = URLSession(configuration: .default) ) {
        self.defaultSession = session
    }
    
    func request(url: String, method: method, success: @escaping (Response?) -> Void, failure: @escaping (Response?) -> Void) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: url) {
            //urlComponents.query = "if we need a query param for particular geometry group"
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                guard let urlResponse = response as? HTTPURLResponse else {
                    failure(nil)
                    return
                }
                
                switch urlResponse.statusCode {
                case 200...300:
                    success(Response(data: data, statusCode: urlResponse.statusCode))
                default:
                    failure(Response(data: data, statusCode: urlResponse.statusCode))
                }
            }
            
            dataTask?.resume()
            
        }
    }
}
