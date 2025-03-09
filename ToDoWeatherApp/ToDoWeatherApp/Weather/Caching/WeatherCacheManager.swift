import Foundation

class WeatherCacheManager: DataProvider {
    typealias T = WeatherCachingModel
#warning("Pass in repo and refactor")
    let repository: RealmRepository
//    let locationManager = UserLocationManager()
    let apiManager = ApiDataManager()
    var isLoading = false
    
    init(_ repository: RealmRepository = RealmRepository()) {
        self.repository = repository
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
    
    func persistWeatherModel(_ idToDelete: String?,
                             name: String,
                             condition: String,
                             temperature: Double,
                             feelsLike: Double,
                             sunriseTime: String,
                             sunsetTime: String,
                             completion: @escaping (WeatherCachingModel?, Error?) -> Void) {
        let newId = UUID().uuidString
        let newWeatherData = WeatherCachingModel(id: newId,
                                                locationName: name,
                                                condition: condition,
                                                temperature: temperature,
                                                feelsLikeTemperature: feelsLike,
                                                sunriseTime: sunriseTime,
                                                sunsetTime: sunsetTime)
        DispatchQueue.main.async {
            if let idToDelete {
                self.refreshCache(idToDelete) {
                    do {
                        try self.create(newWeatherData)
                        completion(newWeatherData, nil)
                    } catch {
                        print("Faiiled to delete \(error)")
                        completion(nil, error)
                    }
                }
            } else {
                do {
                    try self.create(newWeatherData)
                    completion(newWeatherData, nil)
                } catch {
                    print("Faiiled to delete \(error)")
                    completion(nil, error)
                }
            }
        }
    }

//    func getLocation() {
//        locationManager.requestLocation()
//    }
    
    internal func create(_ object: WeatherCachingModel) throws {
        do {
            try repository.create(object)
        } catch {
            // handle error
        }
    }
    
    func readAll() -> [WeatherCachingModel] {
        repository.readAll(T.self)
    }
    
    func delete(_ id: String) throws {
        do {
            try repository.delete(id, ofType: T.self)
        } catch {
            // Handle
        }
    }
    
    func refreshCache(_ id: String?, completion: @escaping () -> ()) {
        if let id {
            do {
                try delete(id)
                completion()
            } catch {
                print(error)
                completion()
            }
        }
    }
}
