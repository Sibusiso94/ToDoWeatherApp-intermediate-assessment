import Foundation
import CoreLocation
import CoreLocationUI

enum ConditionsStrings: String {
    case sunny = "Sunny"
    case overcast = "cloud"
    case rainy = "rain"
    case snow = "snow"
}

enum WeatherErrors {
    
}

protocol WeatherViewModelManager {
    var weatherData: WeatherDomainModel? { get set }
    var isLoading: Bool { get set }
    var didFail: Bool { get set }
    
    func fetchWeatherInformation(_ location: CLLocationCoordinate2D?)
    func setUpDates()
    func setUpCondition()
}

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate, WeatherViewModelManager {
    let dataProvider = WeatherDataProvider()
    let dateManager = DateManager()
    let manager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    
    @Published var weatherData: WeatherDomainModel?
    @Published var date: String = ""
    @Published var time: String = ""
    @Published var condition: ConditionIcon = .sunny
    @Published var isLoading: Bool = false
    @Published var didFail: Bool = false

    override init() {
        super.init()
        manager.delegate = self
        fecthCachedWeatcherData()
        setUpDates()
    }
    
    func fecthCachedWeatcherData() {
        let allData = dataProvider.readAll()
        if let data = allData.first {
            weatherData = data
            setUpCondition()
        }
    }
    
    func setUpDates() {
        // Combine
        date = dateManager.getCompleteDate()
        time = dateManager.getTime()
    }
    
    func setUpCondition() {
        guard let data = weatherData else { return }
        if data.condition.contains(ConditionsStrings.sunny.rawValue) {
            condition = ConditionIcon.sunny
        } else if data.condition.contains(ConditionsStrings.rainy.rawValue) {
            condition = ConditionIcon.rainy
        } else if data.condition.contains("cloud") {
            condition = ConditionIcon.cloud
        } else if data.condition.contains("cloudy") {
            condition = ConditionIcon.cloud
        } else if data.condition.contains(ConditionsStrings.rainy.rawValue) {
            condition = ConditionIcon.overcast
        } else if data.condition.contains(ConditionsStrings.snow.rawValue) {
            condition = ConditionIcon.snow
        }
    }

    private func requestLocation() {
        manager.requestLocation()
    }

#warning("Move to manager")
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        fetchWeatherInformation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func fetchWeatherData() {
        // Add group so only triggers when requestion is done
        requestLocation()
    }
    
    func fetchWeatherInformation(_ location: CLLocationCoordinate2D?) {
        isLoading = true
        let latitude = Double(location?.latitude ?? 0.0)
        let longitude = Double(location?.longitude ?? 0.0)
        dataProvider.fetchData("\(latitude),\(longitude)") { [weak self] data, error in
            if let error {
                self?.isLoading = false
                self?.didFail = true
            }
            
            self?.persistData(data: data)
        }
    }
    
    private func persistData(data: WeatherModel?) {
        guard let data = data else { return }
        dataProvider.persistWeatherModel(weatherData?.id,
                                         name: data.location.name,
                                         condition: data.current.condition.text,
                                         temperature: data.current.tempC,
                                         feelsLike: data.current.feelslikeC,
                                         sunriseTime: data.forecast.forecastday[0].astro.sunrise,
                                         sunsetTime: data.forecast.forecastday[0].astro.sunset) { [weak self] data, error in
            if let error {
                print("Error persisting data: \(error)")
                self?.isLoading = false
                self?.didFail = true
            }
            
            if let data {
                self?.weatherData = data
                self?.isLoading = false
            }
        }
    }
}

