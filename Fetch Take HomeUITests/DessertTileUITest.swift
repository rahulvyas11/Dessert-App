import XCTest

final class DessertTileUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called before the invocation of each test method in the class.
    }

    func testDessertTileDisplaysCorrectly() throws {
        let app = XCUIApplication()
        
        
        let dessertTile = app.otherElements["DessertTile_52893"]
        
        // Verify that the dessert tile exists
        XCTAssertTrue(dessertTile.waitForExistence(timeout: 5), "Dessert tile should exist")
        
        // Verify that the image is displayed
        let imageView = dessertTile.images["DessertImage_52893"]
        XCTAssertTrue(imageView.exists, "Dessert image should exist")
        
        // Verify that the name is displayed correctly
        let nameText = dessertTile.staticTexts["DessertName_52893"]
        XCTAssertTrue(nameText.exists, "Dessert name should be displayed")
        
        // Verify that the subtitle text is displayed correctly
        let subtitleText = dessertTile.staticTexts["DessertSubtitle_52893"]
        XCTAssertTrue(subtitleText.exists, "Subtitle should be displayed")
        
        // Tap the dessert tile
        dessertTile.tap()
        
        // Verify that the navigation to RecipeDetails view happened
        let recipeDetailsView = app.otherElements["RecipeDetailsView"]
        XCTAssertTrue(recipeDetailsView.waitForExistence(timeout: 5), "Recipe details view should be displayed after tapping the dessert tile")
    }
}
