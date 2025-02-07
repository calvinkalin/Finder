//
//  Person.swift
//  Finder
//
//  Created by Ilya Kalin on 06.02.2025.
//

import Foundation
import SwiftUI
import CoreLocation

struct Person: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var isSelected: Bool
    
    private var avatarName: String
    var avatar: Image {
        Image(avatarName)
    }
    
    private var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
}

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}

extension CLLocationCoordinate2D {
    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let to = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return from.distance(from: to)
    }
}
