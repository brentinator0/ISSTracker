//
//  ISSLocationViewController.swift
//  ISSTracker
//
//  Created by Brent Piephoff on 12/24/18.
//  Copyright © 2018 Brent P. All rights reserved.
//

import UIKit
import Mapbox

class ISSLocationViewController: UIViewController {

    var latestLocation: IssLocationQuery.Data.IssLocation?
    var mapView = generateMapView()
    var timer = Timer()
    
    var lat = 0.0
    var long = 0.0
    
    let centerAnnotation = MGLPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        scheduledTimerWithTimeInterval()
    }
    
    private static func generateMapView() -> MGLMapView {
        let url = URL(string: "mapbox://styles/bbpiepho/cjq277dqq304m2rqjwlu5ot97")
        let map = MGLMapView(frame: .zero, styleURL: url)
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return map
    }
    
    private func configureMapView() {
        mapView.frame = self.view.bounds
        mapView.delegate = self

        self.view.addSubview(mapView)
        self.mapView.addAnnotation(self.centerAnnotation)
    }
    
    private func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateISSLocation), userInfo: nil, repeats: true)
    }
    
    @objc private func updateISSLocation() {
        
        apollo.fetch(query: IssLocationQuery(), cachePolicy: .returnCacheDataAndFetch) { result, error in
        guard let issLocation = result?.data?.issLocation else { return }
            
            guard let long = issLocation.longitude, let lat = issLocation.latitude else { return }
            guard let doubleLong = Double(long), let doubleLat = Double(lat) else { return }
            
            self.lat = doubleLat
            self.long = doubleLong
            
            print("New Coordinates: lat:\(doubleLat) long:\(doubleLong)")
            self.mapView.setCenter(CLLocationCoordinate2D(latitude: doubleLat, longitude: doubleLong), zoomLevel: 3.0, animated: true)
            self.centerAnnotation.coordinate = self.mapView.centerCoordinate
            
            // Add marker `hello` to the map.
        }
        
    }

}

extension ISSLocationViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
//        if let radarImage = UIImage(named: "ISS") {
//            let coordinates = MGLCoordinateQuad(
//                topLeft: CLLocationCoordinate2D(latitude: self.lat + 3.0, longitude: self.long - 5.0),
//                bottomLeft: CLLocationCoordinate2D(latitude: self.lat - 5.0, longitude: self.long - 5.0),
//                bottomRight: CLLocationCoordinate2D(latitude: self.lat - 5.0, longitude: self.long + 5.0),
//                topRight: CLLocationCoordinate2D(latitude: self.lat + 3.0, longitude: self.long + 5.0))
//
//            let source = MGLImageSource(identifier: "radar", coordinateQuad: coordinates, image: radarImage)
//            style.addSource(source)
//
//            // Create a raster layer from the MGLImageSource.
//            let radarLayer = MGLRasterStyleLayer(identifier: "radar-layer", source: source)
//
//            // Insert the raster layer below the map's symbol layers.
//            for layer in style.layers.reversed() {
//                if !layer.isKind(of: MGLSymbolStyleLayer.self) {
//                    style.insertLayer(radarLayer, above: layer)
//                    break
//                }
//            }
//        }
    }
}
