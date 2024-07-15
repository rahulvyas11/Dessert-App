import Foundation

struct RecipeList: Codable {
    let meals: [RecipeDetailsModel]?
}

struct RecipeDetailsModel: Hashable, Codable {
    var id: String?
    var name: String?
    var instructions: String?
    var thumbnail: String?
    var ingredients: [String: String] = [:]

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case thumbnail = "strMealThumb"
    }

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
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)

        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKey.self)

        for i in 1...20 { // Assuming a maximum of 20 ingredients and measurements
            let ingredientKey = DynamicCodingKey(stringValue: "strIngredient\(i)")!
            let measureKey = DynamicCodingKey(stringValue: "strMeasure\(i)")!

            if let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: ingredientKey),
               let measurement = try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey),
               !ingredient.isEmpty, !measurement.isEmpty {
                ingredients[ingredient] = measurement
            }
        }
    }

    // Custom initializer for testing
    init(id: String? = nil, name: String? = nil, instructions: String? = nil, thumbnail: String? = nil, ingredients: [String: String] = [:]) {
        self.id = id
        self.name = name
        self.instructions = instructions
        self.thumbnail = thumbnail
        self.ingredients = ingredients
    }
}

extension RecipeDetailsModel {
    func ingredientMeasurePairs() -> [(ingredient: String, measurement: String)] {
        return ingredients.map { ($0.key, $0.value) }
    }
}

