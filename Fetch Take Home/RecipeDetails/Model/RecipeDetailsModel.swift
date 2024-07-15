import Foundation
/// Represents the response for fetching recipe details based on  id.
struct RecipeList: Codable {
    let meals: [RecipeDetailsModel]?
}

struct RecipeDetailsModel: Hashable, Codable {
    var id: String?
    var name: String?
    var instructions: String?
    var thumbnail: String?
    var ingredients: [String] = []
    var measurements: [String] = []

    //coding keys for better naming
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case thumbnail = "strMealThumb"
    }

    //dynamic coding keys to handle n number of instructions and measurements
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
    
    // used to decode json data
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)

        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKey.self)
        
        //counts the number of ingredients and measurements
        var ingredientCount = 0
        var measurementCount = 0
        for key in dynamicContainer.allKeys {
            if key.stringValue.hasPrefix("strIngredient") {
                ingredientCount += 1
            } else if key.stringValue.hasPrefix("strMeasure") {
                measurementCount += 1
            }
        }
        
        //appends all ingredients and measurements that are not empty
        let count = min(ingredientCount, measurementCount)
        if count > 0 {
            for i in 1...count {
                let ingredientKey = DynamicCodingKey(stringValue: "strIngredient\(i)")!
                let measureKey = DynamicCodingKey(stringValue: "strMeasure\(i)")!
                
                if let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: ingredientKey), !ingredient.isEmpty {
                    ingredients.append(ingredient)
                }
                
                if let measurement = try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey), !measurement.isEmpty {
                    measurements.append(measurement)
                }
            }
        }
    }
    // Custom initializer for testing
    init(id: String? = nil, name: String? = nil, instructions: String? = nil, thumbnail: String? = nil, ingredients: [String] = [], measurements: [String] = []) {
        self.id = id
        self.name = name
        self.instructions = instructions
        self.thumbnail = thumbnail
        self.ingredients = ingredients
        self.measurements = measurements
    }

}

//groups ingredients and measurements into pairs. Did not use a dictionary as some recipes have duplicate ingredients. 
extension RecipeDetailsModel {
    func ingredientMeasurePairs() -> [(ingredient: String, measurement: String)] {
        return Array(zip(ingredients, measurements)).filter { !$0.0.isEmpty && !$0.1.isEmpty }
    }
}
