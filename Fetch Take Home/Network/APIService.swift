import Foundation


/// Protocol defining the API service interface.
/// This allows for dependency injection and easier testing.
protocol APIServiceProtocol {
    func get(url: String) async throws -> Data
}

/// Concrete implementation of `APIServiceProtocol` that uses URLSession to fetch data.
class APIService: APIServiceProtocol {
    func get(url: String) async throws -> Data {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
