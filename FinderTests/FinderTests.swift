//
//  FinderTests.swift
//  FinderTests
//
//  Created by Ilya Kalin on 09.02.2025.
//

import XCTest
import CoreLocation
import Combine

@testable import Finder

final class PersonListViewModelTests: XCTestCase {
    
    var viewModel: PersonListViewModel!
    var mockPersonService: MockPersonService!
    
    override func setUp() {
        super.setUp()
        
        let expectation = XCTestExpectation(description: "Setup view model and mock data")
        
        DispatchQueue.main.async {
            self.viewModel = PersonListViewModel()
            self.mockPersonService = MockPersonService()
            self.viewModel.persons = self.mockPersonService.mockPersons
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    override func tearDown() {
        viewModel = nil
        mockPersonService = nil
        super.tearDown()
    }
    
    func testToggleSelection() async {
        let person = mockPersonService.mockPersons.first!
        
        await MainActor.run {
            viewModel.toggleSelection(for: person)
        }
        
        await MainActor.run {
            XCTAssertEqual(viewModel.selectedPerson?.id, person.id, "После выбора пользователя он должен быть выбран")
        }
        
        await MainActor.run {
            viewModel.toggleSelection(for: person)
        }
        
        await MainActor.run {
            XCTAssertNil(viewModel.selectedPerson, "Повторное нажатие должно снять выбор")
        }
    }
    
    func testDistanceCalculation() async {
        let userLocation = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176)
        let person = mockPersonService.mockPersons.first!
        
        await MainActor.run {
            viewModel.userLocation = userLocation
        }
        
        let distance = await MainActor.run {
            return viewModel.distance(to: person)
        }
        
        XCTAssertNotEqual(distance, "?? km", "Расстояние должно рассчитываться корректно")
    }
}

final class PersonServiceTests: XCTestCase {
    @MainActor
    func testLoadPersons() {
        let viewModel = PersonListViewModel()
        let service = PersonService(personListViewModel: viewModel)
        
        XCTAssertFalse(service.persons.isEmpty, "Данные persons не должны быть пустыми после загрузки")
    }
    
    @MainActor
    func testStartUpdatingCoordinatesUpdatesCoordinates() async {
        let viewModel = PersonListViewModel()
        let service = PersonService(personListViewModel: viewModel)
        let initialCoordinates = service.persons[0].coordinates
        
        let task = Task {
            await service.startUpdatingCoordinates()
        }
        
        try? await Task.sleep(nanoseconds: 4_000_000_000)
        task.cancel()
        
        let updatedCoordinates = service.persons[0].coordinates
        XCTAssertNotEqual(
            updatedCoordinates,
            initialCoordinates,
            "Координаты должны измениться после обновления"
        )
    }
}

// MARK: - Mock Data
class MockPersonService {
    let mockPersons: [Person] = [
        Person(id: 1, name: "John Doe", avatarname: "aragorn", coordinates: Coordinates(latitude: 55.7558, longitude: 37.6176)),
        Person(id: 2, name: "Jane Smith", avatarname: "boromir", coordinates: Coordinates(latitude: 55.7600, longitude: 37.6200))
    ]
}
