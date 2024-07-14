import Foundation
import SwiftUI

class DessertListViewModel: ObservableObject {
    @Published var desserts: [Dessert] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func loadDessertData() {
        self.isLoading = true
        self.errorMessage = nil
        APIService.fetchDesserts(onSuccess: { [weak self] desserts in
            DispatchQueue.main.async {
                self?.desserts = desserts
                self?.isLoading = false
            }
        }, onError: { [weak self] error in
            DispatchQueue.main.async {
                self?.errorMessage = "Failed to load data: \(error.localizedDescription)"
                self?.isLoading = false
            }
        })
    }
}
