import XCTest
@testable import Fetch_Take_Home

final class NetworkTests: XCTestCase {
    
    var apiClient: APIClientProtocol!
    var mockAPIService: MockAPIService!
    
    override func setUpWithError() throws {
        mockAPIService = MockAPIService()
        apiClient = APIClient(apiService: mockAPIService)
    }

    override func tearDownWithError() throws {
        apiClient = nil
        mockAPIService = nil
    }

    // Test fetchDesserts with successful response
    func testFetchDessertsSuccess() async throws {
        mockAPIService.mockData = """
        {
            "meals": [
                {
                    "idMeal": "12345",
                    "strMeal": "Test Meal",
                    "strMealThumb": "TestURL"
                }
            ]
        }
        """.data(using: .utf8)!

        do {
            let desserts = try await apiClient.fetchDesserts()
            XCTAssertEqual(desserts.count, 1, "Expected one dessert")
            XCTAssertEqual(desserts.first?.id, "12345", "Expected dessert ID to be 12345")
            XCTAssertEqual(desserts.first?.name, "Test Meal", "Expected dessert name to be Test Meal")
            XCTAssertEqual(desserts.first?.image, URL(string:"TestURL"), "Expected thumbnail URL to match")
        } catch {
            XCTFail("Expected fetchDesserts to succeed, but it failed with error: \(error)")
        }
    }
    // Test fetchDesserts with error response
    func testFetchDessertsFailure() async {
        mockAPIService.shouldReturnError = true

        do {
            _ = try await apiClient.fetchDesserts()
            XCTFail("Expected fetchDesserts to throw an error")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .badURL, "Expected bad URL error")
        }
    }
    
    // Test fetchDesserts with empty response
    func testFetchDessertsEmptyResponse() async throws {
        mockAPIService.mockData = """
        {
            "meals": []
        }
        """.data(using: .utf8)!

        do {
            let desserts = try await apiClient.fetchDesserts()
            XCTAssertTrue(desserts.isEmpty, "Expected desserts to be empty")
        } catch {
            XCTFail("Expected fetchDesserts to handle empty response, but it failed with error: \(error)")
        }
    }

    // Test fetchRecipeDetails with successful response
    func testFetchRecipeDetailsSuccess() async throws {
        mockAPIService.mockData = """
        {
            "meals": [
                {
                    "idMeal": "12345",
                    "strMeal": "Test Meal",
                    "strInstructions": "Test instructions",
                    "strMealThumb": "https://www.example.com/image.jpg"
                }
            ]
        }
        """.data(using: .utf8)!

        do {
            let recipeDetails = try await apiClient.fetchRecipeDetails(mealID: "12345")
            XCTAssertNotNil(recipeDetails, "Expected non-nil recipe details")
            XCTAssertEqual(recipeDetails?.idMeal, "12345", "Expected recipe ID to be 12345")
            XCTAssertEqual(recipeDetails?.strMeal, "Test Meal", "Expected recipe name to be Test Meal")
            XCTAssertEqual(recipeDetails?.strInstructions, "Test instructions", "Expected instructions to match")
        } catch {
            XCTFail("Expected fetchRecipeDetails to succeed, but it failed with error: \(error)")
        }
    }

    // Test fetchRecipeDetails with error response
    func testFetchRecipeDetailsFailure() async {
        mockAPIService.shouldReturnError = true

        do {
            _ = try await apiClient.fetchRecipeDetails(mealID: "12345")
            XCTFail("Expected fetchRecipeDetails to throw an error")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .badURL, "Expected bad URL error")
        }
    }
    
    // Test fetchRecipeDetails with empty response
    func testFetchRecipeDetailsEmptyResponse() async throws {
        mockAPIService.mockData = """
        {
            "meals": []
        }
        """.data(using: .utf8)!

        do {
            let recipeDetails = try await apiClient.fetchRecipeDetails(mealID: "12345")
            XCTAssertNil(recipeDetails, "Expected recipeDetails to be nil for empty response")
        } catch {
            XCTFail("Expected fetchRecipeDetails to handle empty response, but it failed with error: \(error)")
        }
    }
    
    
}

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
