import SwiftUI

enum ConditionIcon: String {
    case sunny = "sun.max"
    case cloudy, overcast
    case cloud
    case rainy = "cloud.rain"
    case snow = "snow"
}

struct WeatherView: View {
    var date: String
    var time: String
    var location: String
    
    var condition: ConditionIcon
    var temperature: String
    
    var conditionDescription: String
    var sunrise: String
    var sunset: String
    
    init(date: String,
         time: String,
         location: String,
         condition: ConditionIcon,
         temperature: String,
         conditionDescription: String,
         sunrise: String,
         sunset: String) {
        self.date = date
        self.time = time
        self.location = location
        self.condition = condition
        self.temperature = temperature
        self.conditionDescription = conditionDescription
        self.sunrise = sunrise
        self.sunset = sunset
    }
    
    var body: some View {
        NavigationStack {
            Spacer()
                .frame(height: 16)
            VStack(alignment: .center, spacing: 50) {
                createTopSection(header: date,
                                 title: time,
                                 subheading: location)
                
                createMiddleSection(imageName: condition.rawValue, title: "\(temperature)°C")
                
                createBottomSection(heading: conditionDescription,
                                    title1: NSLocalizedString("Sunrise_Text", comment: ""),
                                    subtitle1: sunrise,
                                    title2: NSLocalizedString("Sunset_Text", comment: ""),
                                    subtitle2: sunset)
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
                .lineLimit(2)
            Text(title)
                .font(.largeTitle)
            Text(subheading)
                .font(.headline)
                .lineLimit(2)
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
                .opacity(0.4)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Divider()
                .padding(.horizontal, 50)
            
            HStack {
                Spacer()
                VStack {
                    Text(title1)
                        .opacity(0.4)
                    Text(subtitle1)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                Spacer()
                
                VStack {
                    Text(title2)
                        .opacity(0.4)
                    Text(subtitle2)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                Spacer()
            }
        }
    }
}
