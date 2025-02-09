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
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Загрузка...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                    Spacer()
                } else {
                    if let selectedPerson = viewModel.selectedPerson {
                        SelectedPersonRow(person: selectedPerson)
                            .padding()
                    }
                    List(viewModel.persons) { person in
                        PersonRow(
                            person: person,
                            distance: viewModel.distance(to: person),
                            isSelected: viewModel.selectedPerson?.id == person.id
                        )
                        .onTapGesture {
                            viewModel.toggleSelection(for: person)
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
