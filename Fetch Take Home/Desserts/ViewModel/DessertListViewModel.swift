import Foundation
import SwiftUI
/// ViewModel for managing and fetching dessert data.
class DessertListViewModel: ObservableObject {
    @Published var desserts: [Dessert] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    
    private let apiClient: APIClientProtocol

    //dependency injection
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    /// Loads dessert data from the APIClient
    /// This method is annotated with `@MainActor` to ensure it runs on the main thread, as it updates the published properties.
    @MainActor
    func loadDessertData() async {
        self.isLoading = true
        self.errorMessage = nil
        do {
            let desserts = try await apiClient.fetchDesserts() //concurrency control
            self.desserts = desserts
            self.isLoading = false
        } catch {
            self.errorMessage = "Failed to load data: \(error.localizedDescription)"
            self.isLoading = false
        }
    }

    var sortedDesserts: [Dessert] {
        return desserts.sorted()
    }
}
