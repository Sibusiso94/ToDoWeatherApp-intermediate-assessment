import SwiftUI

enum ToDoWeatherTabItem: Hashable {
    case todo
    case weather
}

struct ToDoWeatherTabView: View {
    @State var selectedTab = ToDoWeatherTabItem.todo
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ToDoListView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("To Do")
                }
                .tag(ToDoWeatherTabItem.todo)
            
            WeatherContainerView()
                .tabItem {
                    Image(systemName: "sun.haze.fill")
                    Text("Weather")
                }
                .tag(ToDoWeatherTabItem.weather)
        }
    }
}

#Preview {
    ToDoWeatherTabView()
}
