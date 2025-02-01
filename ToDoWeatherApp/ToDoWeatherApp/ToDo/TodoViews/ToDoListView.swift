import SwiftUI

struct ToDoListView: View {
    @StateObject var viewModel = ToDoListViewModel()
    @State var showPopup = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.toDoTasks.isEmpty {
                    Button {
                        showPopup.toggle()
                    } label: {
                        Text("Add Task")
                    }
                    .padding(.horizontal)
                    .frame(minHeight: 50)
                    .background(.gray.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .background(RoundedRectangle(cornerRadius: 5).stroke().opacity(0.5))
                    .foregroundStyle(.black)
                } else {
                    Section {
                        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                            ForEach(Array(viewModel.toDoTasks.enumerated()), id: \.offset) { index, item in
                                ItemCardView(taskId: item.id,
                                             title: item.title,
                                             description: item.todoDescription,
                                             itemIds: viewModel.getItemIds(),
                                             isCompleted: item.isCompleted) { newValue in
                                    viewModel.updateTask(taskId: item.id, isTaskComplete: newValue)
                                }
                                             .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                                 Button("Delete", systemImage: "trash") {
                                                     viewModel.delete(taskId: item.id)
                                                 }
                                                 .tint(.red)
                                             }
                                       .enableScrollViewSwipeAction()
                            }
                            .padding()
                        }
                    } header: {
                        Text("To do")
                            .font(.headline)
                    }
                }
                
                if !viewModel.completedTasks.isEmpty {
                    Section {
                        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                            ForEach(Array(viewModel.completedTasks.enumerated()), id: \.offset) { index, item in
                                ItemCardView(taskId: item.id,
                                             title: item.title,
                                             description: item.todoDescription,
                                             itemIds: viewModel.getItemIds(),
                                             isCompleted: item.isCompleted) { newValue in
                                    viewModel.updateTask(taskId: item.id, isTaskComplete: newValue)
                                }
                                             .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button("Delete", systemImage: "trash") {
                                        viewModel.delete(taskId: item.id)
                                    }
                                    .tint(.red)
                                }
                          .enableScrollViewSwipeAction()
                            }
                            .padding()
                        }
                    } header: {
                        Text("Completed")
                            .font(.headline)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showPopup.toggle()
                    } label: {
                        Image(systemName: "plus.square.dashed")
                    }

                }
            }
            .sheet(isPresented: $showPopup) {
                AddTaskView(titleInput: $viewModel.newItem.title, descriptionInput: $viewModel.newItem.todoDescription) {
                    viewModel.addToDoItem()
                }
                .alert("Item Successfully Added", isPresented: $viewModel.didSucceed) {
                    Button("OK", role: .cancel) { }
                }
            }
        }
    }
}
