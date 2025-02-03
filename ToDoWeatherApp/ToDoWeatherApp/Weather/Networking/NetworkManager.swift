import Foundation

protocol NetworkManager {
    associatedtype T: Decodable
    
    var hasError: Bool { get set }
    var error: ApiError? { get set }
    
    func createURL(baseURL: String, parameters: [(String, String)]) -> URL?
    func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T?, ApiError>) -> Void)
}

enum ApiError: LocalizedError {
    case failedToDecode
    case noDataReceived
    case invalidUrl
    case custom(error: Error)
    case invalidResponse(response: String)
    
    var errorDescription: String? {
        switch self {
        case .failedToDecode:
            return "Failed to decode response"
        case .noDataReceived:
            return "No data received"
        case .invalidUrl:
            return "Invalid URL"
        case .invalidResponse(let response):
            return "Invalid response received: \(response)"
        case .custom(let error):
            return error.localizedDescription
        }
    }
}

final class NetworkManagerConcreation: NetworkManager {
    typealias T = WeatherModel
    var hasError = false
    var error: ApiError?
    
    func createURL(baseURL: String, parameters: [(String, String)]) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = parameters.map { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
    
    func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T?, ApiError>) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.handleError(ApiError.custom(error: error), completion: completion)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    self?.handleError(ApiError.invalidResponse(response: String(describing: response)), completion: completion)
                    return
                }
                
                guard let data = data else {
                    self?.handleError(ApiError.noDataReceived, completion: completion)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let resultData = try decoder.decode(T.self, from: data)
                    completion(.success(resultData))
                } catch {
                    self?.handleError(ApiError.custom(error: error), completion: completion)
                }
            }
        }.resume()
    }
    
    private func handleError<T>(_ error: ApiError, completion: (Result<T, ApiError>) -> Void) {
        self.hasError = true
        self.error = error
        completion(.failure(error))
    }
}
