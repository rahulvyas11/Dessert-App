import Foundation
import SwiftUI

class DessertListViewModel: ObservableObject {
    @Published var desserts: [Dessert] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    @MainActor
    func loadDessertData() async {
        self.isLoading = true
        self.errorMessage = nil
        do {
            let desserts = try await apiClient.fetchDesserts()
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
