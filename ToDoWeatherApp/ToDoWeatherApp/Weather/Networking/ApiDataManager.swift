import Foundation
import OSLog

class ApiDataManager {
    private let repository: RealmRepository
    private let networkingManager = NetworkManagerConcreation()
    private let baseURL = "https://api.weatherapi.com/v1/forecast.json"
    
    var hasError: Bool = false
    var error: ApiError?
    
    init(repository: RealmRepository) {
        self.repository = repository
    }
    
    func fetchApiData(location: String,
                      completion: @escaping (WeatherModel?, Error?) -> Void) {
        let url = networkingManager.createURL(
            baseURL: baseURL,
            parameters: [
                ("key", "7ade4844a9b349eabb5165409250102"),
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
                    self?.hasError = self?.networkingManager.hasError ?? true
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
