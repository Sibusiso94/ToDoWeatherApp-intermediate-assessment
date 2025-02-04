import XCTest
import RealmSwift
import Testing
@testable import ToDoWeatherApp

class WeatherViewModelTests: XCTestCase {
    var viewModel: MockWeatherViewModel! = nil
    
    override func setUpWithError() throws {
        super.setUp()
        viewModel = MockWeatherViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel.dataProvider.repository.clearRealm()
        super.tearDown()
    }
    
    func testGivenWeatherDataFetchedThenApiCallPasses() {
        viewModel.fetchWeatherData()
        XCTAssertTrue(viewModel.isLoading == false)
    }
    
    func testGivenWeatherDataFetchedThenApiCallDoesNotPasses() {
        viewModel.didFail = true
        viewModel.fetchWeatherData()
    }
}

class MockWeatherViewModel: WeatherViewModelManager {
    var weatherData: WeatherDomainModel?
    var apiDataManager = MockApiDataProvider()
    
    var isLoading: Bool = false
    var didFail: Bool = false
    
    var dataProvider: MockDataProvider
    
    init() {
        self.dataProvider = MockDataProvider()
        apiDataManager.didFailToFetch = didFail
    }
    
    func fecthCachedWeatcherData() {
        let data = dataProvider.readAll()
        weatherData = data.first
    }
    
    func fetchWeatherData() {
        isLoading = true
        apiDataManager.fetchApiData(location: "64.183,-51.75") { [weak self] data, error in
            if let error {
                self?.isLoading = false
                self?.didFail = true
            }
            
            if let data {
                self?.dataProvider.create(MockWeatherData.domainDataModel)
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
    typealias T = WeatherDomainModel
    
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
    var baseURL: String = ""
    var didFailToFetch: Bool = false
    var mockData: WeatherModel?
    
    func fetchApiData(location: String, completion: @escaping (ToDoWeatherApp.WeatherModel?, (any Error)?) -> Void) {
        if didFailToFetch {
            completion(nil, NSError(domain: "No matching location found.", code: 1006, userInfo: nil))
        } else {
            completion(mockData, nil)
        }
    }
}

class MockWeatherData {
    static let domainDataModel = WeatherDomainModel(locationName: "Johannesburg", condition: "Sunny", temperature: 28.7, feelsLikeTemperature: 31.2, sunriseTime: "05:43 am", sunsetTime: "06:59 pm")
    
    static let dataModel = WeatherModel(location: Location(name: "Johannesburg"),
                                        current: Current(tempC: 28.7, tempF: 30, condition: Condition(text: "Sunny"), humidity: 20, cloud: 9, feelslikeC: 31.2),
                                        forecast: Forecast(forecastday: [Forecastday(astro: Astro(sunrise: "05:43 am", sunset: "06:59 pm"))]))
}
