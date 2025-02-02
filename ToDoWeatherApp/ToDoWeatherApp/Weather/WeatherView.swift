import SwiftUI
import CoreLocationUI

struct WeatherView: View {
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 50) {
                createTopSection(header: "Monday, 27th April",
                                 title: "6:27am",
                                 subheading: "London")
                
                createMiddleSection(imageName: "cloud", title: "19°C")
                
                createBottomSection(heading: "Feels like: 38°C",
                                    title1: "Sunrise",
                                    subtitle1: "05:25",
                                    title2: "Sunrise",
                                    subtitle2: "18:47")
                
                LocationButton(.currentLocation) {
                    viewModel.fetchWeatherData(from: "Johannesburg")
                }
//                Button("Click") {
//                    viewModel.fetchWeatherData(from: "Johannesburg")
//                }
            }
        }
    }
}

extension WeatherView {
    @ViewBuilder
    func createTopSection(header: String,
                          title: String,
                          subheading: String) -> some View {
        VStack(spacing: 8) {
            Text(header)
                .font(.headline)
            Text(title)
                .font(.largeTitle)
            Text(subheading)
                .font(.headline)
        }
    }
    
    @ViewBuilder
    func createMiddleSection(imageName: String,
                          title: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 140, height: 120)
                .opacity(0.7)
            Text(title)
                .font(.system(size: 50))
        }
    }
    
    @ViewBuilder
    func createBottomSection(heading: String,
                          title1: String,
                         subtitle1: String,
                         title2: String,
                         subtitle2: String) -> some View {
        VStack {
            Text(heading)
            Divider()
                .padding(.horizontal, 50)
            
            HStack {
                Spacer()
                VStack {
                    Text(title1)
                    Text(subtitle1)
                }
                Spacer()
                
                VStack {
                    Text(title2)
                    Text(subtitle2)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    WeatherView()
}
