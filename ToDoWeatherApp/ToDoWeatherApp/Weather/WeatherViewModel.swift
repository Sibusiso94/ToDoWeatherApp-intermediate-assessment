import Foundation

class WeatherViewModel: ObservableObject {
    let apiManager = ApiDataManager(repository: RealmRepository())
    
    init() {
        apiManager.fetchApiData(location: "South Africa") { data, error in
            if let error {
                print(error)
            }
            
            if let data {
                print(data)
            }
        }
    }
}

