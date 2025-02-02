import Foundation

class WeatherDataProvider: DataProvider {
    typealias T = WeatherDomainModel
    
    private let repository = RealmRepository()
//    let locationManager = UserLocationManager()
    let apiManager: ApiDataManager
    
    init() {
        self.apiManager = ApiDataManager(repository: repository)
    }
    
    func fetchWeatherData(_ location: String) {
        fetchData(location)
    }
    
    private func fetchData(_ location: String)  {
        apiManager.fetchApiData(location: location) { data, error in
            if let error {
                print(error)
            }
            
            if let data {
                self.persistWeatherModel(name: data.location.name,
                                    condition: data.current.condition.text,
                                         temperature: data.current.tempC,
                                         feelsLike: data.current.feelslikeC,
                                         sunriseTime: data.forecast.forecastday[0].astro.sunrise,
                                         sunsetTime: data.forecast.forecastday[0].astro.sunset)
            }
        }
    }
    
    private func persistWeatherModel(name: String,
                                     condition: String,
                                     temperature: Double,
                                     feelsLike: Double,
                                     sunriseTime: String,
                                     sunsetTime: String) {
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
        } catch {
            //
        }
    }
    
//    func getLocation() {
//        locationManager.requestLocation()
//    }
    
    internal func create(_ object: WeatherDomainModel) throws {
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
        //
    }
    
    
}
