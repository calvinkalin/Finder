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
                if viewModel.userLocation == nil {
                    ZStack {
                        Text("Геолокация отключена. Включите доступ в настройках.")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
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
            }
            .navigationTitle("Люди рядом")
            .onAppear {
                viewModel.setupLocationManager()
            }
            .alert("Геолокация отключена", isPresented: $viewModel.showLocationAlert) {
                Button("Настройки") {
                    if let settings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settings)
                    }
                }
                Button("Отмена", role: .cancel) { }
            } message: {
                Text("Включите геолокацию для корректной работы приложения.")
            }
        }
    }
}
