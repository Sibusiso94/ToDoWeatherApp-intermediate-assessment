import SwiftUI
import CoreLocationUI

struct WeatherContainerView: View {
    @StateObject var viewModel: WeatherViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: WeatherViewModel())
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                if let data = viewModel.weatherData {
                    VStack {
                        WeatherView(date: viewModel.date,
                                    time: viewModel.time,
                                    location: data.locationName,
                                    condition: viewModel.condition,
                                    temperature: "\(data.temperature)",
                                    conditionDescription: data.condition,
                                    sunrise: data.sunriseTime,
                                    sunset: data.sunsetTime)
                    }
                }
                
                LocationButton(.currentLocation) {
                    viewModel.fetchWeatherData()
                }
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .labelStyle(.titleAndIcon)
                .symbolVariant(.fill)
                .tint(.blue.opacity(0.5))
            }
            .onAppear() {
                viewModel.setUpDates()
            }
            .overlay {
                if viewModel.isLoading {
                    VStack {
                        Text("Loading...")
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    .padding()
                    .background(.gray.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .alert("Something went wrong. \nplease try again later", isPresented: $viewModel.didFail) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}

#Preview {
    WeatherContainerView()
}
