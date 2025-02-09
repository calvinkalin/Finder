//
//  ModelData.swift
//  Finder
//
//  Created by Ilya Kalin on 07.02.2025.
//

import Foundation

@MainActor
class PersonService: ObservableObject {
    @Published var persons: [Person] = []
    
    weak var personListViewModel: PersonListViewModel?
    
    init(personListViewModel: PersonListViewModel) {
        self.personListViewModel = personListViewModel
        loadPersons()
    }
    
    func loadPersons() {
        guard let url = Bundle.main.url(forResource: "personData", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let loadedPersons = try? JSONDecoder().decode([Person].self, from: data) else {
            print("Failed to load data")
            return
        }
        self.persons = loadedPersons
    }
    
    func startUpdatingCoordinates() async {
        while true {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            
            let updatedPersons = self.persons.map { person in
                if let pinnedPerson = self.personListViewModel?.pinnedPerson, person.id == pinnedPerson.id {
                    return person
                }
                
                var updatedPerson = person
                updatedPerson.coordinates.latitude += Double.random(in: -0.0005...0.0005)
                updatedPerson.coordinates.longitude += Double.random(in: -0.0005...0.0005)
                return updatedPerson
            }
            
            await MainActor.run {
                self.objectWillChange.send()
                self.persons = updatedPersons
            }
        }
    }
}
