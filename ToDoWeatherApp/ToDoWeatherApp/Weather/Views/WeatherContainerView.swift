import SwiftUI

struct WeatherContainerView: View {
    @StateObject var viewModel: WeatherViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: WeatherViewModel())
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                WeatherView(date: "Monday, 27th April",
                            time: "6:27am",
                            location:"London",
                            condition: "cloud",
                            temperature: "19",
                            feelsLike: "32",
                            sunrise: "05:25",
                            sunset: "18:47") {
                    viewModel.fetchWeatherData(from: "Johannesburg")
                }
            }
        }
    }
}



#Preview {
    WeatherContainerView()
}
