import Foundation

class APIService {
    static func get(url: String) async throws -> Data {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    static func fetchDesserts() async throws -> [Dessert] {
        let data = try await get(url: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")
        let response = try JSONDecoder().decode(DessertTilesReponse.self, from: data)
        
        if let meals = response.meals {
            let filteredMeals = meals.filter { meal in
                guard let strMeal = meal.strMeal, !strMeal.isEmpty,
                      let idMeal = meal.idMeal, !idMeal.isEmpty,
                      meal.strMealThumb != nil else {
                    return false
                }
                return true
            }
            return filteredMeals
        } else {
            return []
        }
    }
}
