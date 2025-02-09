//
//  SelectedPersonRow.swift
//  Finder
//
//  Created by Ilya Kalin on 09.02.2025.
//

import SwiftUI

struct SelectedPersonRow: View {
    var person: Person
    
    var body: some View {
        VStack {
            Text("Выбран: \(person.name)")
                .font(.headline)
            Text("Координаты: \(person.locationCoordinate.latitude) - \(person.locationCoordinate.longitude)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.cyan.opacity(0.1))
        .cornerRadius(10)
    }
}
