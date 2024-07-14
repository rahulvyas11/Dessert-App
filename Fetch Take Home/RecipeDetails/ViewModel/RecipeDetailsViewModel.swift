import Foundation

@MainActor
class RecipeDetailsViewModel: ObservableObject {
    @Published var recipe: RecipeDetailsModel?

    func loadRecipeDetails(mealID: String) async {
        do {
            guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            let recipeList = try JSONDecoder().decode(RecipeList.self, from: data)
            if let meals = recipeList.meals, !meals.isEmpty {
                self.recipe = meals[0]
                print("Recipe loaded: \(self.recipe)")
               
            }
        } catch {
            print(error)
        }
    }
}


