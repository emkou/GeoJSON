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
private let sthlmTraficKey: String = "f9cbaa1a-7ee8-4fb6-93b9-2703c89532dc"

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
    
    func request(with url: routes,  success: @escaping (FeatureCollection) -> Void, failure: @escaping (String) -> Void) {
        request.request(url: url.path, method: .get, success: { (response) in

            do {
                let decoder = JSONDecoder()
                let collection = try decoder.decode(FeatureCollection.self, from: response)

                DispatchQueue.main.async {
                    success(collection)
                }
            } catch {
                print("Decoding", error.localizedDescription)
                failure("Could not map geometry objects")
            }
        }, failure: { (response) in
            failure(response.description)
        })
        
    }
}
