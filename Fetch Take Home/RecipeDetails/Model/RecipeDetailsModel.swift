import Foundation

struct RecipeList: Codable {
    let meals: [RecipeDetailsModel]?
}

struct RecipeDetailsModel: Hashable, Codable {
    var idMeal: String?
    var strMeal: String?
    var strInstructions: String?
    var strMealThumb: String?
    var ingredients: [String] = []
    var measurements: [String] = []

    struct DynamicCodingKey: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            self.intValue = intValue
            self.stringValue = "\(intValue)"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        
        idMeal = try container.decodeIfPresent(String.self, forKey: DynamicCodingKey(stringValue: "idMeal")!)
        strMeal = try container.decodeIfPresent(String.self, forKey: DynamicCodingKey(stringValue: "strMeal")!)
        strInstructions = try container.decodeIfPresent(String.self, forKey: DynamicCodingKey(stringValue: "strInstructions")!)
        strMealThumb = try container.decodeIfPresent(String.self, forKey: DynamicCodingKey(stringValue: "strMealThumb")!)

        
        var ingredientCount = 0
        var measurementCount=0
        for key in container.allKeys {
            if key.stringValue.hasPrefix("strIngredient") {
                ingredientCount=ingredientCount+1
                }
            else if key.stringValue.hasPrefix("strMeasure")
            {
                measurementCount=measurementCount+1
            }
        }
        
        for i in 1...min(ingredientCount, measurementCount) {
            let ingredientKey = DynamicCodingKey(stringValue: "strIngredient\(i)")!
            let measureKey = DynamicCodingKey(stringValue: "strMeasure\(i)")!
            
            if let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey), !ingredient.isEmpty {
                ingredients.append(ingredient)
            }
            
            if let measurement = try container.decodeIfPresent(String.self, forKey: measureKey), !measurement.isEmpty {
                measurements.append(measurement)
            }
        }

    }
}

extension RecipeDetailsModel {
    func ingredientMeasurePairs() -> [(ingredient: String, measurement: String)] {
        return Array(zip(ingredients, measurements)).filter { !$0.0.isEmpty && !$0.1.isEmpty }
    }
}
