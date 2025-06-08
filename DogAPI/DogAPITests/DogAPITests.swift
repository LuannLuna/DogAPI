//
//  DogAPITests.swift
//  DogAPITests
//
//  Created by Luann Luna on 07/06/25.
//

import XCTest
import SwiftData
@testable import DogAPI

@MainActor
final class DogAPITests: XCTestCase {
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!

    override func setUp() async throws {
        try await super.setUp()
        let schema = Schema([FavoriteBreed.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        modelContext = ModelContext(modelContainer)
    }

    override func tearDown() async throws {
        modelContext = nil
        modelContainer = nil
        try await super.tearDown()
    }

    func test_add_favorites() async throws {
        // GIVEN
        let breed = Breed(name: "Husky")
        let favoriteBreed = FavoriteBreed(name: breed.name)

        // WHEN
        modelContext.insert(favoriteBreed)
        try modelContext.save()

        // THEN
        let descriptor = FetchDescriptor<FavoriteBreed>()
        let favorites = try modelContext.fetch(descriptor)
        XCTAssertEqual(favorites.count, 1)
        XCTAssertEqual(favorites.first?.name, "Husky")
    }

    func test_remove_favorites() async throws {
        // GIVEN
        let breed = Breed(name: "Husky")
        let favoriteBreed = FavoriteBreed(name: breed.name)
        modelContext.insert(favoriteBreed)
        try modelContext.save()

        // WHEN
        modelContext.delete(favoriteBreed)

        // THEN
        let descriptor = FetchDescriptor<FavoriteBreed>()
        let favorites = try modelContext.fetch(descriptor)
        XCTAssertEqual(favorites.count, 0)
    }
}
