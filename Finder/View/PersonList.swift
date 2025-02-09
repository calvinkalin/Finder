//
//  PersonList.swift
//  Finder
//
//  Created by Ilya Kalin on 07.02.2025.
//

import SwiftUI

struct PersonList: View {
    @StateObject var viewModel = PersonListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let pinnedPerson = viewModel.pinnedPerson {
                    SelectedPersonRow(person: pinnedPerson)
                        .padding()
                }
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Загрузка...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                    Spacer()
                } else {
                    List(viewModel.persons) { person in
                        NavigationLink(destination: MapViewScreen(person: person)) {
                            PersonRow(
                                person: person,
                                distance: viewModel.distance(to: person),
                                isPinned: viewModel.pinnedPerson?.id == person.id,
                                onPin: { viewModel.pinUser(person) }
                            )
                        }
                    }
                }
            }
            .navigationTitle("Люди рядом")
            .onAppear {
                viewModel.setupLocationManager()
            }
        }
    }
}
