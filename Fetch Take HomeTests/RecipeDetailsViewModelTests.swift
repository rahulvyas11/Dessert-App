import XCTest
@testable import Fetch_Take_Home

final class RecipeDetailsViewModelTests: XCTestCase {
    var viewModel: RecipeDetailsViewModel!
    var mockAPIClient: MockAPIClient!

    @MainActor override func setUpWithError() throws {
        mockAPIClient = MockAPIClient()
        viewModel = RecipeDetailsViewModel(apiClient: mockAPIClient)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockAPIClient = nil
    }

    @MainActor
    func testLoadRecipeDetailsSuccess() async throws {
        let mockRecipe = RecipeDetailsModel(
            id: "123",
            name: "Test Meal",
            instructions: "Test Instructions",
            thumbnail: "https://www.example.com/image.jpg",
            ingredients: ["Ingredient1", "Ingredient2"],
            measurements: ["1 cup", "2 tsp"]
        )

        mockAPIClient.mockRecipeDetails = mockRecipe

        await viewModel.loadRecipeDetails(mealID: "123")

        XCTAssertNotNil(viewModel.recipe, "Recipe should not be nil after loading")
        XCTAssertEqual(viewModel.recipe?.name, "Test Meal", "Recipe name should be 'Test Meal'")
        XCTAssertEqual(viewModel.recipe?.instructions, "Test Instructions", "Recipe instructions should be 'Test Instructions'")
        XCTAssertEqual(viewModel.recipe?.thumbnail, "https://www.example.com/image.jpg", "Recipe thumbnail should match")
        XCTAssertEqual(viewModel.recipe?.ingredients, ["Ingredient1", "Ingredient2"], "Ingredients should match")
        XCTAssertEqual(viewModel.recipe?.measurements, ["1 cup", "2 tsp"], "Measurements should match")
    }
    
    @MainActor
    func testIngredientMeasurePairsFiltering() async throws {
        mockAPIClient.mockRecipeDetails = RecipeDetailsModel(
            id: "123",
            name: "Test Meal",
            instructions: "Test Instructions",
            thumbnail: "https://www.example.com/image.jpg",
            ingredients: ["Ingredient1", "Ingredient2", "", "Ingredient3", "","","","Ingredient4"],
            measurements: ["1 cup", "2 tsp", "", "4 tbsp", "5 oz","","","Measurement4"]
        )

        await viewModel.loadRecipeDetails(mealID: "123")

        XCTAssertNotNil(viewModel.recipe, "Recipe should not be nil after loading")
        
        let ingredientMeasurePairs = viewModel.recipe?.ingredientMeasurePairs() ?? []
        XCTAssertEqual(ingredientMeasurePairs.count, 4, "There should be 4 valid ingredient-measure pairs")
        XCTAssertEqual(ingredientMeasurePairs[0].ingredient, "Ingredient1", "First ingredient should be 'Ingredient1'")
        XCTAssertEqual(ingredientMeasurePairs[0].measurement, "1 cup", "First measurement should be '1 cup'")
        
        XCTAssertEqual(ingredientMeasurePairs[1].ingredient, "Ingredient2", "Second ingredient should be 'Ingredient2'")
        XCTAssertEqual(ingredientMeasurePairs[1].measurement, "2 tsp", "Second measurement should be 2tsp")
        
        XCTAssertEqual(ingredientMeasurePairs[2].ingredient, "Ingredient3", "Third ingredient should be 'Ingredient3'")
        XCTAssertEqual(ingredientMeasurePairs[2].measurement, "4 tbsp", "Third measurement should be '4 tbsp'")
        XCTAssertEqual(ingredientMeasurePairs[3].ingredient, "Ingredient4", "Fourth ingredient should be 'Ingredient5'")
        XCTAssertEqual(ingredientMeasurePairs[3].measurement, "Measurement4", "Fourth measurement should be 'Measurement4'")
        
    }

    @MainActor
    func testLoadRecipeDetailsFailure() async throws {
        mockAPIClient.shouldReturnError = true

        await viewModel.loadRecipeDetails(mealID: "123")

        XCTAssertNil(viewModel.recipe, "Recipe should be nil after failing to load")
    }

    @MainActor
    func testLoadRecipeDetailsEmptyResponse() async throws {
        mockAPIClient.mockRecipeDetails = nil

        await viewModel.loadRecipeDetails(mealID: "123")

        XCTAssertNil(viewModel.recipe, "Recipe should be nil after loading empty response")
    }
    
    
}
