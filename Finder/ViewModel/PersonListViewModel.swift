//
//  PersonListViewModel.swift
//  Finder
//
//  Created by Ilya Kalin on 09.02.2025.
//

import SwiftUI
import CoreLocation
import Combine

@MainActor
class PersonListViewModel: NSObject, ObservableObject {
    @Published var persons: [Person] = []
    @Published var selectedPerson: Person?
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var isLoading = true
    @Published var showLocationAlert = false
    
    private var personService: PersonService?
    private let locationManager = CLLocationManager()
    private var cancellable: Set<AnyCancellable> = []

    override init() {
        super.init()
        
        Task {
            let service = PersonService(personListViewModel: self)
            self.personService = service
            self.isLoading = true
            self.persons = service.persons
            self.isLoading = false
            
            service.$persons
                .receive(on: DispatchQueue.main)
                .sink { [weak self] newPersons in
                    self?.persons = newPersons
                }
                .store(in: &cancellable)
            
            await service.startUpdatingCoordinates()
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            handleLocationDenied()
        @unknown default:
            break
        }
    }

    
    func distance(to person: Person) -> String {
        let referenceLocation: CLLocationCoordinate2D
        
        if let selectedPerson = selectedPerson {
            referenceLocation = selectedPerson.locationCoordinate
        } else if let userLocation = userLocation {
            referenceLocation = userLocation
        } else {
            return "?? km"
        }
        
        let personLocation = person.locationCoordinate
        let distanceMeters = referenceLocation.distance(to: personLocation)
        return String(format: "%.1f km", distanceMeters / 1000)
    }
    
    func toggleSelection(for person: Person) {
        selectedPerson = (selectedPerson?.id == person.id) ? nil : person
        objectWillChange.send()
    }
    
    private func handleLocationDenied() {
        self.userLocation = nil
        self.showLocationAlert = true
    }
}

// MARK: - CLLocationManagerDelegate
extension PersonListViewModel: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        
        Task { @MainActor in
            self.userLocation = lastLocation.coordinate
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        Task { @MainActor in
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                self.locationManager.startUpdatingLocation()
            case .denied, .restricted:
                self.handleLocationDenied()
            default:
                break
            }
        }
    }
}
