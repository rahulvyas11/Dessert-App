import XCTest
@testable import Fetch_Take_Home

final class DessertListViewModelTests: XCTestCase {
    var viewModel: DessertListViewModel!
    var mockAPIClient: MockAPIClient!

    @MainActor override func setUpWithError() throws {
        mockAPIClient = MockAPIClient()
        viewModel = DessertListViewModel(apiClient: mockAPIClient)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockAPIClient = nil
    }

    @MainActor
    func testLoadDessertDataSuccess() async throws {
        mockAPIClient.mockDesserts = [
            Dessert(name: "Cake", image: URL(string:"https://www.example.com/image.jpg"), id: "123")
        ]
        
        await viewModel.loadDessertData()
        
        XCTAssertFalse(viewModel.desserts.isEmpty, "Desserts should not be empty after loading")
        XCTAssertEqual(viewModel.desserts.count, 1, "Desserts count should be 1")
        XCTAssertEqual(viewModel.desserts.first?.name, "Cake", "Dessert name should be 'Cake'")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil after successful loading")
    }
    
    @MainActor
    func testDessertsAreSorted() async throws {
        mockAPIClient.mockDesserts = [
            Dessert(name: "Brownie", image: URL(string: "https://www.example.com/image2.jpg"), id: "124"),
            Dessert(name: "Apple Pie", image: URL(string: "https://www.example.com/image1.jpg"), id: "123"),
            Dessert(name: "Kwiktrip Donuts", image: URL(string: "https://www.example.com/image3.jpg"), id: "126"),
            Dessert(name: "Cheesecake", image: URL(string: "https://www.example.com/image3.jpg"), id: "125")
        ]
        
        await viewModel.loadDessertData()
        
        let sortedDesserts = viewModel.sortedDesserts
        
        XCTAssertEqual(sortedDesserts.count, 4, "Desserts count should be 4")
        XCTAssertEqual(sortedDesserts[0].name, "Apple Pie", "First dessert should be 'Apple Pie'")
        XCTAssertEqual(sortedDesserts[1].name, "Brownie", "Second dessert should be 'Brownie'")
        XCTAssertEqual(sortedDesserts[2].name, "Cheesecake", "Third dessert should be 'Cheesecake'")
        XCTAssertEqual(sortedDesserts[3].name, "Kwiktrip Donuts", "Fourth dessert should be 'Kwiktrip Donuts'")
    }
    
    @MainActor
    func testLoadDessertDataFailure() async throws {
        mockAPIClient.shouldReturnError = true
        
        await viewModel.loadDessertData()
        
        XCTAssertTrue(viewModel.desserts.isEmpty, "Desserts should be empty after failure")
        XCTAssertNotNil(viewModel.errorMessage, "Error message should be set after failure")
    }

    @MainActor
    func testLoadDessertDataEmptyResponse() async throws {
        mockAPIClient.mockDesserts = []
        
        await viewModel.loadDessertData()
        
        XCTAssertTrue(viewModel.desserts.isEmpty, "Desserts should be empty after empty response")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil after empty response")
    }
}

