import Foundation

protocol APIServiceProtocol {
    func get(url: String) async throws -> Data
}

class APIService: APIServiceProtocol {
    func get(url: String) async throws -> Data {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
