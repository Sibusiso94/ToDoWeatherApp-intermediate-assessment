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
    var data: WeatherModel?
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
            Task {
                do {
                    data = try await networkingManager.fetchData(from: url)
                    completion(data, nil)
                } catch {
                    os_log("%@", type: .debug, error as CVarArg)
//                    self.error = error as! ApiError
                    completion(nil, error)
                }
            }
        } else {
            os_log("Invalid URL")
            completion(nil, ApiError.invalidUrl)
        }
    }
}
