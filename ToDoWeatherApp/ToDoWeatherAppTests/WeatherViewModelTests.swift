import XCTest
import RealmSwift
import Testing
import CoreLocation
import CoreLocationUI
@testable import ToDoWeatherApp

class WeatherViewModelTests: XCTestCase {
    var viewModel: MockWeatherViewModel! = nil
    
    override func setUpWithError() throws {
        super.setUp()
    }
    
    override func tearDownWithError() throws {
        viewModel.dataProvider.repository.clearRealm()
        super.tearDown()
    }
    
    func testGivenWeatherDataFetchedThenApiCallPasses() {
        viewModel = MockWeatherViewModel(didFail: false)
        viewModel.fetchWeatherInformation(MockWeatherData.mockLocationData)
        viewModel.fecthCachedWeatcherData()
        
        XCTAssertNotNil(viewModel.weatherData)
    }
    
    func testGivenWeatherDataFetchedThenApiCallDoesNotPasses() {
        viewModel = MockWeatherViewModel(didFail: true)
        viewModel.fetchWeatherInformation(MockWeatherData.mockLocationData)
        viewModel.fecthCachedWeatcherData()
        
        XCTAssertNil(viewModel.weatherData)
    }
}

class MockWeatherViewModel: WeatherViewModelManager {
    var weatherData: WeatherCachingModel?
    var apiDataManager: MockApiDataProvider
    
    var isLoading: Bool = false
    var didFail: Bool
    
    var dataProvider: MockDataProvider
    let dateManager = DateManager()
    
    init(didFail: Bool) {
        self.didFail = didFail
        self.dataProvider = MockDataProvider()
        apiDataManager = MockApiDataProvider(didFailToFetch: didFail)
    }
    
    func fecthCachedWeatcherData() {
        let data = dataProvider.readAll()
        weatherData = data.first
    }
    
    func fetchWeatherInformation(_ location: CLLocationCoordinate2D?) {
        isLoading = true
        apiDataManager.fetchApiData(location: "64.183,-51.75") { [weak self] data, error in
            if let error {
                self?.isLoading = false
                self?.didFail = true
            }
            
            if let data {
                self?.dataProvider.create(MockWeatherData.domainDataModel)
                self?.isLoading = false
            }
        }
    }
    
    func setUpDates() {
        //
    }
    
    func setUpCondition() {
        //
    }
}

class MockDataProvider: DataProvider {
    typealias T = WeatherCachingModel
    
    var repository = RealmRepository()
    let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")
    
    init() {
        self.repository.realm = try! Realm(configuration: config)
    }
    
    func readAll() -> [T] {
        repository.readAll(T.self)
    }
    
    func delete(_ id: String) throws {
        do {
            try repository.delete(id, ofType: T.self)
        } catch {
            print(error)
        }
    }
    
    func create(_ object: T) {
        do {
            try repository.create(object)
        } catch {
            print(error)
        }
    }
}

class MockApiDataProvider: ApiDataProvider {
    var baseURL: String
    var didFailToFetch: Bool
    var mockData: WeatherModel?
    
    init(baseURL: String = "", didFailToFetch: Bool) {
        self.baseURL = baseURL
        self.didFailToFetch = didFailToFetch
    }
    
    func fetchApiData(location: String, completion: @escaping (ToDoWeatherApp.WeatherModel?, (any Error)?) -> Void) {
        if didFailToFetch {
            completion(nil, NSError(domain: "No matching location found.", code: 1006, userInfo: nil))
        } else {
            completion(MockWeatherData.dataModel, nil)
        }
    }
}

class MockWeatherData {
    static let domainDataModel = WeatherCachingModel(locationName: "Johannesburg", condition: "Sunny", temperature: 28.7, feelsLikeTemperature: 31.2, sunriseTime: "05:43 am", sunsetTime: "06:59 pm")
    
    static let dataModel = WeatherModel(location: Location(name: "Johannesburg"),
                                        current: Current(tempC: 28.7, tempF: 30, condition: Condition(text: "Sunny"), humidity: 20, cloud: 9, feelslikeC: 31.2),
                                        forecast: Forecast(forecastday: [Forecastday(astro: Astro(sunrise: "05:43 am", sunset: "06:59 pm"))]))
    
    static let mockLocationData = CLLocationCoordinate2D(latitude: 64.183, longitude: -51.75)
    
//    Date(2025-02-05 13:45:23 +0000)
//    15:45
//    Wednesday, 5 February 2025
}
