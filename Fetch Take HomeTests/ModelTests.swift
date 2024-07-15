import XCTest
@testable import Fetch_Take_Home

//Tests to Ensure that RecipeDetailsModels functions as required
final class ModelTests: XCTestCase {

    func testRecipeDetailsModelDecoding() throws {
        let jsonData = """
        {
            "idMeal": "12345",
            "strMeal": "Test Meal",
            "strInstructions": "Test Instructions",
            "strMealThumb": "https://www.example.com/image.jpg",
            "strIngredient1": "Ingredient1",
            "strIngredient2": "Ingredient2",
            "strMeasure1": "1 cup",
            "strMeasure2": "2 tsp"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let recipe = try decoder.decode(RecipeDetailsModel.self, from: jsonData)

        XCTAssertEqual(recipe.id, "12345")
        XCTAssertEqual(recipe.name, "Test Meal")
        XCTAssertEqual(recipe.instructions, "Test Instructions")
        XCTAssertEqual(recipe.thumbnail, "https://www.example.com/image.jpg")
        XCTAssertEqual(recipe.ingredients, ["Ingredient1", "Ingredient2"])
        XCTAssertEqual(recipe.measurements, ["1 cup", "2 tsp"])
    }

    func testRecipeDetailsModelDecodingWithEmptyValues() throws {
        let jsonData = """
        {
            "idMeal": "12345",
            "strMeal": "Test Meal",
            "strInstructions": "Test Instructions",
            "strMealThumb": "https://www.example.com/image.jpg",
            "strIngredient1": "",
            "strIngredient2": "Ingredient2",
            "strMeasure1": "",
            "strMeasure2": "2 tsp"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let recipe = try decoder.decode(RecipeDetailsModel.self, from: jsonData)

        XCTAssertEqual(recipe.id, "12345")
        XCTAssertEqual(recipe.name, "Test Meal")
        XCTAssertEqual(recipe.instructions, "Test Instructions")
        XCTAssertEqual(recipe.thumbnail, "https://www.example.com/image.jpg")
        XCTAssertEqual(recipe.ingredients, ["Ingredient2"])
        XCTAssertEqual(recipe.measurements, ["2 tsp"])
    }
}
