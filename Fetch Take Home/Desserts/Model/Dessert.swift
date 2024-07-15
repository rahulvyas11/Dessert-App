import Foundation

struct DessertTilesResponse: Codable {
    let meals: [Dessert]?
}

struct Dessert: Hashable, Codable, Comparable {
    let name: String?
    let image: URL?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case image = "strMealThumb"
        case id = "idMeal"
    }
    
    static func < (lhs: Dessert, rhs: Dessert) -> Bool {
        if let lhsMeal = lhs.name, let rhsMeal = rhs.name {
            return lhsMeal < rhsMeal
        }
        return false
    }
}
