//
//  FeatureCollection.swift
//  GeoJSON
//
//  Created by Emil Doychinov on 3/10/19.
//  Copyright © 2019 Emil Doychinov. All rights reserved.
//

import Foundation
import MapKit

typealias OverlayShape =  MKMultiPoint & MKOverlay

struct FeatureCollection: Decodable {
   let features: [Feature]
}

struct Feature: Decodable {
    let type: String
    let geometry: Geometry
    let properties: [String:GeoJSONPropertyType]
}

struct Geometry: Decodable {
    let type: GeometryType
    let coordinates: [CLLocationCoordinate2D]
}

struct GeoJSONPropertyType: Decodable {
    public let jsonValue: Any
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            jsonValue = intValue
        } else if let stringValue = try? container.decode(String.self) {
            jsonValue = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            jsonValue = boolValue
        } else if let doubleValue = try? container.decode(Double.self) {
            jsonValue = doubleValue
        } else {
            throw DecodingError.typeMismatch(GeoJSONPropertyType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported type"))
        }
    }
}

enum GeometryType: String, Codable {
    case LineString, Polygon
}

// MARK: Extensions
extension Feature {
    var mapKitGeometry: OverlayShape {
        switch geometry.type {
            case .LineString:
                return MKPolyline(coordinates: geometry.coordinates, count: geometry.coordinates.count)
            case .Polygon:
                return MKPolygon(coordinates: geometry.coordinates, count: geometry.coordinates.count)
        }
    }
}

extension CLLocationCoordinate2D: Decodable {
    public init(from decoder: Decoder) throws {
        let value = try [Double](from: decoder)
        guard let latitude = value.last, let longitude = value.first else {
            throw DecodingError.valueNotFound(Double.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "could not find lat long data"))
        }
        self.init(latitude: latitude, longitude: longitude)
    }
}



