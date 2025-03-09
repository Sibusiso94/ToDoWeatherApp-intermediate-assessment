import Foundation

protocol NetworkManager {
    associatedtype T: Decodable
    
    var hasError: Bool { get set }
    var error: ApiError? { get set }
    
    func createURL(baseURL: String, parameters: [(String, String)]) -> String?
//    func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T?, ApiError>) -> Void)
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
    
    func createURL(baseURL: String, parameters: [(String, String)]) -> String? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = parameters.map { URLQueryItem(name: $0.0, value: $0.1) }

        return components?.url?.absoluteString
    }

    func fetchData(from url: String) async throws -> WeatherModel {
        let url = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        let request = URLRequest(url: url!)

        let (data, response) = try await URLSession.shared.data(for: request)
        let fetchedData = try JSONDecoder().decode(WeatherModel.self, from: try mapResponse(response: (data,response)))

        return fetchedData
    }

    private func handleError<T>(_ error: ApiError, completion: (Result<T, ApiError>) -> Void) {
        self.hasError = true
        self.error = error
        completion(.failure(error))
    }

    func mapResponse(response: (data: Data, response: URLResponse)) throws -> Data {
        guard let httpResponse = response.response as? HTTPURLResponse else {
            return response.data
        }

        switch httpResponse.statusCode {
        case 200..<300:
            return response.data
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 402:
            throw NetworkError.paymentRequired
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 413:
            throw NetworkError.requestEntityTooLarge
        case 422:
            throw NetworkError.unprocessableEntity
        default:
            throw NetworkError.http(httpResponse: httpResponse, data: response.data)
        }
    }
}
