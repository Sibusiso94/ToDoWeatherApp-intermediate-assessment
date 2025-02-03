import SwiftUI
import CoreLocationUI

struct WeatherView: View {
    var date: String
    var time: String
    var location: String
    
    var condition: String
    var temperature: String
    
    var feelsLike: String
    var sunrise: String
    var sunset: String
    
    var action: () -> Void
    
    init(date: String,
         time: String,
         location: String,
         condition: String,
         temperature: String,
         feelsLike: String,
         sunrise: String,
         sunset: String,
         action: @escaping () -> Void) {
        self.date = date
        self.time = time
        self.location = location
        self.condition = condition
        self.temperature = temperature
        self.feelsLike = feelsLike
        self.sunrise = sunrise
        self.sunset = sunset
        self.action = action
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 50) {
                createTopSection(header: date,
                                 title: time,
                                 subheading: location)
                
                createMiddleSection(imageName: condition, title: "\(temperature)°C")
                
                createBottomSection(heading: "Feels like: \(feelsLike)°C",
                                    title1: "Sunrise",
                                    subtitle1: sunrise,
                                    title2: "Sunrise",
                                    subtitle2: sunset)
                
                LocationButton(.currentLocation) {
                    action()
                }
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .labelStyle(.titleAndIcon)
                .symbolVariant(.fill)
                .tint(.blue.opacity(0.5))
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
