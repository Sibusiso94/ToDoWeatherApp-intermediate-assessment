import Foundation

struct WeatherModel: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

// MARK: - Current
struct Current: Codable {
    let tempC, tempF: Double
    let humidity, cloud: Int
    let feelslikeC: Double

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case tempF = "temp_f"
        case humidity, cloud
        case feelslikeC = "feelslike_c"
    }
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [Forecastday]
}

// MARK: - Forecastday
struct Forecastday: Codable {
    let astro: Astro

    enum CodingKeys: String, CodingKey {
        case astro
    }
}

// MARK: - Astro
struct Astro: Codable {
    let sunrise, sunset: String

    enum CodingKeys: String, CodingKey {
        case sunrise, sunset
    }
}

// MARK: - Location
struct Location: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}
