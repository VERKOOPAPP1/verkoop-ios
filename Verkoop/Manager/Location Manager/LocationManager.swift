//
//  LocationManager.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//


import CoreLocation

protocol CustomLocationManagerDelegate  {
    func accessDenied()
    func accessRestricted()
    func fetchLocation(location:CLLocation)
}

class LocationManager:NSObject {
    
    static var shairedInstance = LocationManager()
    var locationManager  = CLLocationManager()
    var currentLocation:CLLocation?
    var delegate:CustomLocationManagerDelegate?
    var isLocaitonSent = false
    var isFirstAttemp = true
    
    func locationRequest() {
        isLocaitonSent = false
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            let status = CLLocationManager.authorizationStatus()
            checkLocationStatus(status: status)
        }
    }
    
    func checkLocationStatus(status:CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,.authorizedWhenInUse :
            locationManager.startUpdatingLocation()
        case .denied:
            isFirstAttemp = false
            delegate?.accessDenied()
        case .notDetermined:
            isFirstAttemp = true
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            delegate?.accessRestricted()
        @unknown default:
            Console.log("Do Nothing")
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let userLocation = locations.last
        Console.log(userLocation?.coordinate)
        currentLocation = userLocation
        if let location = currentLocation , !isLocaitonSent {
            isLocaitonSent = true
            delegate?.fetchLocation(location:location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
}
