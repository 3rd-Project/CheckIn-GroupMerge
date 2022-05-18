//
//  LocationManager.swift
//  ApusCheckIn
//
//  Created by Han Gyul Kim on 2022/02/17.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    var locationStatus: CLAuthorizationStatus?
    var lastLocation: CLLocation?
    var distance: Int = -1 
    @Published var distanceHandler: Int = -1

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        distance = Int(round(processLocation.getDistanceFromCluster(lat: userLatitude, lon: userLongitude) / 1000))
        if (distance != distanceHandler) {
            distanceHandler = distance
        }
    }
    
    /* below is what I appended */
    private var userLatitude: Double { lastLocation?.coordinate.latitude ?? 0 }
    private var userLongitude: Double { lastLocation?.coordinate.longitude ?? 0 }
    private let processLocation = ProcessLocation()
    
    var myDistanceFromCluster: String {
        if distance < 1{
            return "Check In Available"
        } else {
            return "My distance from Cluster: \(distance) km"
        }
    }
    
    var isNear: Bool {
        processLocation.isNear(lat: userLatitude, lon: userLongitude)
    }
}
