import Foundation

struct WeatherDomainModel {
    let date: String
    let time: String
    let location: String
    let temperature: String
    let condition: String
    let conditionIcon: ConditionIcon
    let sunriseTime: String
    let sunsetTime: String

    init(date: String,
         time: String,
         location: String,
         temperature: String,
         condition: String,
         conditionIcon: ConditionIcon,
         sunriseTime: String,
         sunsetTime: String) {
        self.date = date
        self.time = time
        self.location = location
        self.temperature = temperature
        self.condition = condition
        self.conditionIcon = conditionIcon
        self.sunriseTime = sunriseTime
        self.sunsetTime = sunsetTime
    }
}
