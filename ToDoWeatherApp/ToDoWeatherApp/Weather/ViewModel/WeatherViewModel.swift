import Foundation
import CoreLocation
import CoreLocationUI

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    let dataProvider = WeatherDataProvider()
    let manager = CLLocationManager()
    var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        fecthWeatcherData()
    }
    
    func fecthWeatcherData() {
        let data = dataProvider.readAll()
        print(data)
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        let latitude = Double(location?.latitude ?? 0.0)
        let longitude = Double(location?.longitude ?? 0.0)
        dataProvider.fetchWeatherData("\(latitude),\(longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func fetchWeatherData(from location: String) {
        // Add group so only triggers when requestion is done
        requestLocation()
    }
    
}

