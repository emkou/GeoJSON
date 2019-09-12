//
//  ViewController.swift
//  GeoJSON
//
//  Created by Emil Doychinov on 5/29/19.
//  Copyright © 2019 Emil Doychinov. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView!
    private let locationHelper = LocationHelper()
    private let geometryFactory = GeometryFactory()
    private let blurredView = BlurrView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The project and its content was used during an internal company presentation
        // on using Swift, Codable, MapKit and URLSession to serialize and display Geometry primitives
        // the goal of the presnetatio was to demonstrate how easy it is to avoid external dependencies
        // when working with these geomentry types
        // for more information https://en.wikipedia.org/wiki/GeoJSON
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        blurredView.addToView(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationHelper.track(completionCall: { [weak self] (location) in
            self?.showOnMap(location: location)
            self?.blurredView.hide()
        }) {  [weak self] (error) in
            self?.blurredView.showError(error: error)
        }
    }
    
    @IBAction private func getLocations(_ sender: Any) {
        guard let latestLocation = locationHelper.latestLocation else {
            return
        }
        
        geometryFactory.request(with: .areasInRadius(latitude: latestLocation.coordinate.latitude, longitude: latestLocation.coordinate.longitude), success: { [weak self] (collection) in
            for feature in collection.features {
                self?.mapView.addOverlay(feature.mapKitGeometry)
            }
        }) { (code) in
            print("code")
        }
    }
    
    private func showOnMap(location: CLLocation ) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay =  overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: overlay)
            renderer.strokeColor = UIColor.green
            renderer.lineWidth = 10
            renderer.alpha = 0.5
            
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
}
