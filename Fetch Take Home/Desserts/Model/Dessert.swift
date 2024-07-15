import Foundation

/// Represents the response for fetching dessert tiles.
struct DessertTilesResponse: Codable {
    let meals: [Dessert]?
}

/// Represents a dessert item.
/// This struct conforms to `Hashable` and `Codable` to support easy decoding from JSON data and use in collections.
/// It also conforms to `Comparable` to allow sorting by name.
struct Dessert: Hashable, Codable, Comparable {
    let name: String?
    let image: URL?
    let id: String?
    
    //coding keys allow for better names
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case image = "strMealThumb"
        case id = "idMeal"
    }
    
    /// Compares two `Dessert` objects by their names.
    /// This allows sorting desserts alphabetically by their names.
    static func < (lhs: Dessert, rhs: Dessert) -> Bool {
        if let lhsMeal = lhs.name, let rhsMeal = rhs.name {
            return lhsMeal < rhsMeal
        }
        return false
    }
}
