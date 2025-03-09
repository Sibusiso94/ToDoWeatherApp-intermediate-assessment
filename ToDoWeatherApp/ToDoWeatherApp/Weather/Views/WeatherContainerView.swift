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
                    VStack {
                        if let data = viewModel.data {
                            WeatherView(data: data)
                        }
                    }
                
                LocationButton(.currentLocation) {
                    viewModel.fetch()
                }
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .labelStyle(.titleAndIcon)
                .symbolVariant(.fill)
                .tint(.blue.opacity(0.5))
            }
            .overlay {
                if viewModel.isLoading {
                    VStack {
                        Text(NSLocalizedString("Loading_text", comment: ""))
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    .padding()
                    .background(.gray.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .alert(NSLocalizedString("Weather_Error_Text", comment: ""), isPresented: $viewModel.didFail) {
                Button(NSLocalizedString("Alert_Button_Text", comment: ""), role: .cancel) { }
            }
        }
    }
}
