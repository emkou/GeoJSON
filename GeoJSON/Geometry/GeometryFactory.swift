//
//  GeometryFactory.swift
//  GeoJSON
//
//  Created by Emil Doychinov on 6/22/19.
//  Copyright © 2019 Emil Doychinov. All rights reserved.
//

import Foundation
import MapKit

private let sthlmTraficBase: String = "https://openparking.stockholm.se/LTF-Tolken/"
private let sthlmTraficKey: String = ""

enum routes {
    case areasInRadius(latitude: Double, longitude: Double)
    
    var path: String {
        switch self {
        case .areasInRadius(let latitude, let longitude):
            return "\(sthlmTraficBase)v1/ptillaten/within?radius=200&lat=\(latitude)&lng=\(longitude)&maxFeatures=200&outputFormat=json&apiKey=\(sthlmTraficKey)"
        }
    }
}

class GeometryFactory {
    var request: RequestProtocol
    
    init(request: RequestProtocol = Request()) {
        self.request = request
    }
    
    func request(with url: routes,  success: @escaping (FeatureCollection) -> Void, failure: @escaping (Int?) -> Void) {
        request.request(url: url.path, method: .get, success: { (response) in
            
            guard let data = response?.data else {
                failure(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let collection = try decoder.decode(FeatureCollection.self, from: data)

                DispatchQueue.main.async {
                    success(collection)
                }
            } catch {
                print("Decoding", error)
            }
        }, failure: { (response) in
            failure(response?.statusCode)
        })
    }
}
