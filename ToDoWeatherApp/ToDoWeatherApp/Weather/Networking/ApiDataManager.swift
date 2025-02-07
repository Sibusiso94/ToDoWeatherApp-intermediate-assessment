import Foundation
import CoreLocation
import OSLog

protocol ApiDataProvider {
    var baseURL: String { get }
    func fetchApiData(location: String,
                      completion: @escaping (WeatherModel?, Error?) -> Void)
}

class ApiDataManager: ApiDataProvider {
    private let networkingManager = NetworkManagerConcreation()
    internal let baseURL = "https://api.weatherapi.com/v1/forecast.json"
    var error: ApiError?
    
    func fetchApiData(location: String,
                      completion: @escaping (WeatherModel?, Error?) -> Void) {
        let url = networkingManager.createURL(
            baseURL: baseURL,
            parameters: [
                ("key", Secrets.apikey),
                ("q", location),
                ("days", "1"),
                ("aqi", "no"),
                ("alerts", "no")
            ]
        )
        
        if let url = url {
            networkingManager.fetchData(from: url) { [weak self] (result: Result<WeatherModel?, ApiError>) in
                switch result {
                case .success(let data):
                    completion(data, nil)
                    os_log("API called successfully")
                case .failure(let error):
                    os_log("%@", type: .debug, self?.networkingManager.error.debugDescription ?? "")
                    self?.error = error
                    completion(nil, error)
                }
            }
        } else {
            os_log("Invalid URL")
            completion(nil, ApiError.invalidUrl)
        }
    }
}
