import Foundation

protocol ViewModelManager {
    func fetch()
}

class WeatherViewModel: ObservableObject, ViewModelManager {
    @Published var data: WeatherDomainModel?
    @Published var isLoading: Bool = false
    @Published var didFail: Bool = false
    private let dataProvider = WeatherDomainManager()

    init() {
        dataProvider.setUpDates()
        setUpData()
    }

    func fetch() {
        // Needs a completion or hasData will try async await then fecthCachedWeatcherData called within dataProvider
        dataProvider.fetchWeatherData {
            setUpData()
        }
    }

    private func setUpData() {
        if let weatherData = dataProvider.weatherData {
            data = WeatherDomainModel(date: dataProvider.date,
                                      time: dataProvider.time,
                                      location: weatherData.locationName,
                                      temperature: "\(weatherData.temperature)",
                                      condition: weatherData.condition,
                                      conditionIcon: dataProvider.condition,
                                      sunriseTime: weatherData.sunriseTime,
                                      sunsetTime: weatherData.sunsetTime)
        }
    }
}
