//
//  MapView.swift
//  Finder
//
//  Created by Ilya Kalin on 09.02.2025.
//

import SwiftUI
import MapKit

struct MapViewScreen: View {
    var person: Person
    @ObservedObject var locationManager = UserLocation()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: [person]) { person in
                MapAnnotation(coordinate: person.locationCoordinate) {
                    VStack {
                        person.avatar
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        
                        Image(systemName: "mappin")
                            .foregroundColor(.red)
                    }
                }
            }
            .frame(height: 300)
            .onAppear {
                region.center = person.locationCoordinate
            }
            
            Text("Расстояние до \(person.name): \(distanceToPerson()) км")
                .padding()
            
            Spacer()
        }
        .navigationTitle(person.name)
    }
    
    func distanceToPerson() -> String {
        guard let userLocation = locationManager.userLocation else { return "???" }
        let distance = userLocation.distance(to: person.locationCoordinate) / 1000
        return String(format: "%.2f", distance)
    }
}
