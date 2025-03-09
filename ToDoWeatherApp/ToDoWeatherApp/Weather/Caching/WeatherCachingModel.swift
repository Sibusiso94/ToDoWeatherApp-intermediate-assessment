import Foundation
import RealmSwift

class WeatherCachingModel: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var locationName: String
    @Persisted var condition: String
    @Persisted var temperature: Double
    @Persisted var feelsLikeTemperature: Double
    @Persisted var sunriseTime: String
    @Persisted var sunsetTime: String
    
    convenience init(id: String = UUID().uuidString,
                     locationName: String,
                     condition: String,
                     temperature: Double,
                     feelsLikeTemperature: Double,
                     sunriseTime: String,
                     sunsetTime: String) {
        self.init()
        self.id = id
        self.locationName = locationName
        self.condition = condition
        self.temperature = temperature
        self.feelsLikeTemperature = feelsLikeTemperature
        self.sunriseTime = sunriseTime
        self.sunsetTime = sunsetTime
    }
    
    override class func primaryKey() -> String? {
         "id"
    }
}
