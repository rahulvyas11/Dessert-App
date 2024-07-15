import Foundation

protocol APIClientProtocol {
    func fetchDesserts() async throws -> [Dessert]
    func fetchRecipeDetails(mealID: String) async throws -> RecipeDetailsModel?
}

class APIClient: APIClientProtocol {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func fetchDesserts() async throws -> [Dessert] {
        let data = try await apiService.get(url: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")
        let response = try JSONDecoder().decode(DessertTilesResponse.self, from: data)
        
        if let meals = response.meals {
            let filteredMeals = meals.filter { meal in
                guard let name = meal.name, !name.isEmpty,
                      let id = meal.id, !id.isEmpty,
                      meal.image != nil else {
                    return false
                }
                return true
            }
            return filteredMeals
        } else {
            return []
        }
    }
    
    func fetchRecipeDetails(mealID: String) async throws -> RecipeDetailsModel? {
        let data = try await apiService.get(url: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)")
        let recipeList = try JSONDecoder().decode(RecipeList.self, from: data)
        return recipeList.meals?.first
    }
}
