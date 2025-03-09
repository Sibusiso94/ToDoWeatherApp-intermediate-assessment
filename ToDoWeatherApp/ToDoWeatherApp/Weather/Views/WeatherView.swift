import SwiftUI

struct WeatherView: View {
    var data: WeatherDomainModel

    init(data: WeatherDomainModel) {
        self.data = data
    }
    
    var body: some View {
        NavigationStack {
            Spacer()
                .frame(height: 16)
            VStack(alignment: .center, spacing: 35) {
                createTopSection(header: data.date,
                                 title: data.time,
                                 subheading: data.location)

                createMiddleSection(imageName: data.conditionIcon.rawValue, title: "\(data.temperature)°C")

                createBottomSection(heading: data.condition,
                                    title1: NSLocalizedString("Sunrise_Text", comment: ""),
                                    subtitle1: data.sunriseTime,
                                    title2: NSLocalizedString("Sunset_Text", comment: ""),
                                    subtitle2: data.sunsetTime)
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
