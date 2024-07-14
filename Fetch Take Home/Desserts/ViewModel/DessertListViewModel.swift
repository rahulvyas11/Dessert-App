import Foundation
import SwiftUI

@MainActor
class DessertListViewModel: ObservableObject {
    @Published var desserts: [Dessert] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func loadDessertData() async {
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let desserts = try await APIService.fetchDesserts()
            self.desserts = desserts
        } catch {
            self.errorMessage = "Failed to load data: \(error.localizedDescription)"
        }
        
        self.isLoading = false
    }
}
