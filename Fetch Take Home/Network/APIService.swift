//
//  APIStandard.swift
//  Fetch Take Home
//
//  Created by Rahul Vyas on 5/15/24.
//

import Foundation

class APIService {
    static func get(url: String, onSuccess: @escaping (Data) -> (), onError: @escaping (Error) -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let errorData = error {
                    onError(errorData)
                }
                return
            }
            
            onSuccess(data)
        }
        task.resume()
    }
    static func fetchDesserts(onSuccess: @escaping ([Dessert]) -> (), onError: @escaping (Error) -> ()) {
        get(url: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert", onSuccess: { data in
            do {
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
                    onSuccess(filteredMeals)
                } else {
                    onSuccess([])
                }
            } catch {
                onError(error)
            }
        }, onError: { error in
            onError(error)
        })
    }
}
