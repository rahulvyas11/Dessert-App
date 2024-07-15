import Foundation
/// ViewModel for managing and fetching recipe details data.
@MainActor
class RecipeDetailsViewModel: ObservableObject {
    @Published var recipe: RecipeDetailsModel?

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func loadRecipeDetails(mealID: String) async {
        do {
            if let recipe = try await apiClient.fetchRecipeDetails(mealID: mealID) {
                self.recipe = recipe
            }
        } catch {
            print(error)
        }
    }
}
