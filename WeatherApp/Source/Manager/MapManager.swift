//
//  MapManager.swift
//  WeatherApp
//
//  Created by Vika on 7/30/19.
//  Copyright © 2019 Vika. All rights reserved.
//

import CoreLocation

protocol MapDelegate {
    func locationUpdated(to location: CLLocation)
}

protocol MapProtocol {
    var delegate: MapDelegate? { set get }
    func getMapAuthorization()
}

class MapManager: NSObject {
    private let desiredAccuracy = 1.0
    private let locationManager = CLLocationManager()
    private var _delegate: MapDelegate?
}

extension MapManager: MapProtocol {
    public var delegate: MapDelegate? {
        get { return _delegate }
        set { _delegate = newValue }
    }
    
    public func getMapAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            prepareAuthorization()
            prepareLocationManager()
            startLocationUpdate()
            return
        }
    }
    
    private func prepareAuthorization() {
        if CLLocationManager.authorizationStatus() == .restricted
            || CLLocationManager.authorizationStatus() == .denied
            || CLLocationManager.authorizationStatus() == .notDetermined {
            
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func prepareLocationManager() {
        locationManager.desiredAccuracy = self.desiredAccuracy
        locationManager.delegate = self
    }
    
    private func startLocationUpdate() {
        locationManager.startUpdatingLocation()
    }
}

extension MapManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count == 0 { return  }
        self.delegate?.locationUpdated(to: locations[0])
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { }
}
