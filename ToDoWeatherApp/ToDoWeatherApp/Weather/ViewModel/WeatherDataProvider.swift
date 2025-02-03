import Foundation

class WeatherDataProvider: DataProvider {
    typealias T = WeatherDomainModel
    
    private let repository = RealmRepository()
//    let locationManager = UserLocationManager()
    let apiManager: ApiDataManager
    var isLoading = false
    
    init() {
        self.apiManager = ApiDataManager(repository: repository)
    }
    
//    func fetchWeatherData(_ location: String) {
//        fetchData(location)
//    }
    
    func fetchData(_ location: String, completion: @escaping (WeatherModel?, Error?) -> Void)  {
        isLoading = true
        apiManager.fetchApiData(location: location) { data, error in
            completion(data, error)
        }
    }
    
    func persistWeatherModel(name: String,
                                     condition: String,
                                     temperature: Double,
                                     feelsLike: Double,
                                     sunriseTime: String,
                             sunsetTime: String,
                             completion: @escaping (WeatherDomainModel?, Error?) -> Void) {
        let newId = UUID().uuidString
        let newWeatherData = WeatherDomainModel(id: newId,
                                                locationName: name,
                                                condition: condition,
                                                temperature: temperature,
                                                feelsLikeTemperature: feelsLike,
                                                sunriseTime: sunriseTime,
                                                sunsetTime: sunsetTime)
        do {
            try create(newWeatherData)
            completion(newWeatherData, nil)
        } catch {
            completion(nil, error)
        }
    }
    
//    func getLocation() {
//        locationManager.requestLocation()
//    }
    
    internal func create(_ object: WeatherDomainModel) throws {
        clearRealm()
        do {
            try repository.create(object)
        } catch {
            // handle error
        }
    }
    
    func readAll() -> [WeatherDomainModel] {
        repository.readAll(T.self)
    }
    
    func delete(_ id: String) throws {
        do {
            try repository.delete(id, ofType: T.self)
        } catch {
            // Handle
        }
    }
    
    func clearRealm() {
        repository.clearRealm()
    }
}
