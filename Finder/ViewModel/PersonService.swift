//
//  ModelData.swift
//  Finder
//
//  Created by Ilya Kalin on 07.02.2025.
//

import Foundation

@Observable
class PersonService {
    @Published var persons: [Person] = []
    
    init() {
        loadPersons()
        startUpdatingCoordinates()
    }
    
    private func loadPersons() {
        guard let url = Bundle.main.url(forResource: "personData", withExtension: "json"),
                let data = try? Data(contentsOf: url),
                let loadedPersons = try? JSONDecoder().decode([Person].self, from: data) else {
            print("Failed to load data")
            return
        }
        self.persons = loadedPersons
    }
    
    private func startUpdatingCoordinates() {
        Task {
            while true {
                try await Task.sleep(nanoseconds: 3_000_000_000)
                DispatchQueue.main.async {
                    self.persons = self.persons.map({ person in
                        var updatedPerson = person
                        updatedPerson.coordinates.latitude += Double.random(in: -0.0005...0.0005)
                        updatedPerson.coordinates.longitude += Double.random(in: -0.0005...0.0005)
                        return updatedPerson
                    })
                }
            }
        }
    }
}
