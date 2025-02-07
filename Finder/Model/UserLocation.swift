//
//  UserLocation.swift
//  Finder
//
//  Created by Ilya Kalin on 07.02.2025.
//

import Foundation
import CoreLocation

class UserLocation: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
    }
}
