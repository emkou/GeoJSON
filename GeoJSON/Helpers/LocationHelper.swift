//
//  LocationManager.swift
//  GeoJSON
//
//  Created by Emil Doychinov on 6/25/19.
//  Copyright © 2019 Emil Doychinov. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    typealias completionCall = (CLLocation) -> Void
    private var completionCall: completionCall?
    
    typealias failureCall = (LocationError) -> Void
    private var failureCall: failureCall?
    
    private let locationManager = CLLocationManager()
    
    var latestLocation: CLLocation?
    
    override init() {
        super.init()
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        } else {
            self.failureCall?(.disabledServices)
        }
    }
    
    func track(completionCall: @escaping completionCall, failureCall: @escaping failureCall) {
        self.completionCall = completionCall
        self.failureCall = failureCall
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let lastLocation = locations.last, let completionCall = self.completionCall {
            self.latestLocation = lastLocation
            completionCall(lastLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.failureCall?(.failedLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            self.failureCall?(.deniedPermission)
        default:
            print(status.rawValue)
        }
    }
}

enum LocationError {
    case deniedPermission
    case disabledServices
    case failedLocation
}
