//
//  MockAPIClient.swift
//  Fetch Take HomeTests
//
//  Created by Rahul Vyas on 7/14/24.
//
import Foundation
@testable import Fetch_Take_Home
//MockAPIClient to pass mock data for clearer unit tests.
class MockAPIClient: APIClientProtocol {
    var shouldReturnError = false
    var mockDesserts: [Dessert] = []
    var mockRecipeDetails: RecipeDetailsModel?

    func fetchDesserts() async throws -> [Dessert] {
        if shouldReturnError {
            throw URLError(.badURL)
        }
        return mockDesserts
    }

    func fetchRecipeDetails(mealID: String) async throws -> RecipeDetailsModel? {
        if shouldReturnError {
            throw URLError(.badURL)
        }
        return mockRecipeDetails
    }
}

//MockAPIService to pass mock data for clearer unit tests.
class MockAPIService: APIServiceProtocol {
    var shouldReturnError = false
    var mockData: Data?

    func get(url: String) async throws -> Data {
        if shouldReturnError {
            throw URLError(.badURL)
        }
        return mockData ?? Data()
    }
}
