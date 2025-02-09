//
//  PersonListViewModel.swift
//  Finder
//
//  Created by Ilya Kalin on 09.02.2025.
//

import SwiftUI
import CoreLocation

@Observable
class PersonListViewModel: NSObject, CLLocationManagerDelegate {
    @Published var persons: [Person] = []
    @Published var selectedPerson: Person?
    @Published var userLocation: CLLocationCoordinate2D?
    
    private let locationManager = CLLocationManager()
    private let personService = PersonService()
    
    override init() {
        super.init()
        self.persons = personService.persons
        
        Task {
            for await newPersons in personService.$persons.values {
                self.persons = newPersons
            }
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last?.coordinate
    }
    
    func distance(to person: Person) -> String {
        guard let userLocation = userLocation else { return "?? km" }
        
        let personLocation = person.locationCoordinate
        let distanceMeters = userLocation.distance(to: personLocation)
        return String(format: "%.1f km", distanceMeters / 1000)
    }
    
    func toggleSelection(for person: Person) {
        selectedPerson = (selectedPerson?.id == person.id) ? nil : person
    }
}
