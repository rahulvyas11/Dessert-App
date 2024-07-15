//
//  MockAPIClient.swift
//  Fetch Take HomeTests
//
//  Created by Rahul Vyas on 7/14/24.
//
import Foundation
@testable import Fetch_Take_Home

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
