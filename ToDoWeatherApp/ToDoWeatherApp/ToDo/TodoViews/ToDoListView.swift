import SwiftUI

struct ToDoListView: View {
    var mock: [ToDoItem] = [ToDoItem(title: "Cook", todoDescription: "Lasagna", isCompleted: true),
                             ToDoItem(title: "Clean", todoDescription: "Clean the Kitchen floor, counter and cupboards"),
                             ToDoItem(title: "Work", todoDescription: "Continue Personal project"),
                             ToDoItem(title: "Eat", todoDescription: "Eat cooked lasagna", isCompleted: true),
                             ToDoItem(title: "Sleep", todoDescription: "get rest for the next day", isCompleted: true)]
    var body: some View {
        ScrollView {
            Section {
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                    ForEach(mock) { item in
                        ItemCardView(title: item.title,
                                     description: item.todoDescription,
                                     isCompleted: item.isCompleted) {
                            //
                        }
                    }
                    .padding()
                }
            } header: {
                Text("To do")
                    .font(.headline)
            }
            
            Section {
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                    ForEach(mock) { item in
                        ItemCardView(title: item.title,
                                     description: item.todoDescription,
                                     isCompleted: item.isCompleted) {
                            //
                        }
                    }
                    .padding()
                }
            } header: {
                Text("Completed")
                    .font(.headline)
            }
        }
    }
}

#Preview {
    ToDoListView()
}
