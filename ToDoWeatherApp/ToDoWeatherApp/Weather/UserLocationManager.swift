//import CoreLocation
//import CoreLocationUI
//
//final class UserLocationManager: NSObject, CLLocationManagerDelegate {
//    let manager = CLLocationManager()
//
//    var location: CLLocationCoordinate2D?
//
//    override init() {
//        super.init()
//        manager.delegate = self
//    }
//
//    func requestLocation() {
//        manager.requestLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        location = locations.first?.coordinate
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
//        print("Failed to get location: \(error.localizedDescription)")
//    }
//}
