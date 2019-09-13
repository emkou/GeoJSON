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

enum HttpStatus: Error {
    case ok
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case internalError
    case unknown
    
    init(with code: Int) {
        switch code {
        case 200...204: self = .ok
        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 403: self = .forbidden
        case 404: self = .notFound
        case 500...510: self = .internalError
        default: self = .unknown
        }
    }
    
    var description: String {
        var descr = ""
        switch self {
        case .ok:
            descr = "OK 200"
        case .badRequest:
            descr = "The server could not understand the request due to invalid request syntax"
        case .unauthorized:
            descr = "Authenticate needed in order to get the requested response"
        case .forbidden:
            descr = "No access rights to access this resource"
        case .notFound:
            descr = "The requested resource is not found"
        case .internalError:
            descr = "Server error"
        case .unknown:
            descr = "Request error"
        }
        
       return descr
    }
}

protocol RequestProtocol {
    func request(url: String, method: method, success: @escaping (Data) -> Void, failure: @escaping (HttpStatus) -> Void)
}

//TODO: include POST handling
class Request: RequestProtocol {
    
    private let session: RequestSession!
    
    init(with session: RequestSession = URLSession(configuration: .default) ) {
        self.session = session
    }
    
    
    func request(url: String, method: method, success: @escaping (Data) -> Void, failure: @escaping (HttpStatus) -> Void) {
       
        if var urlComponents = URLComponents(string: url) {
            //urlComponents.query = "if we need a query param for particular geometry group"
            guard let url = urlComponents.url else { return }

           session.request(with: url) { (result) in
                switch result {
                case .success(let data):
                    success(data)
                    break
                case .failure(let error):
                    failure(error)
                    break
                }
            
            }
        }
    }
}

protocol RequestSession {
    func request(with url: URL, result: @escaping (Result<(Data), HttpStatus>) -> Void)
}

extension URLSession: RequestSession {

    func request(with url: URL, result: @escaping (Result<(Data), HttpStatus>) -> Void) {
        
        let task = dataTask(with: url) { (data, response, error) in
            guard error == nil, let response = response as? HTTPURLResponse, let data = data else {
                result(.failure(HttpStatus(with: 0)))
                return
            }
            
            switch response.statusCode {
            case 200...204:
                result(.success(data))
            default:
                result(.failure(HttpStatus(with: response.statusCode)))
            }
        }
        
        task.resume()
    }
}
