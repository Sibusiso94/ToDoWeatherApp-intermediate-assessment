import SwiftUI

struct ToDoListView: View {
    @StateObject var viewModel: ToDoListViewModel
    @State var showPopup: Bool
    @State var showDeleteAlert: Bool
//    @State var itemId = ""
    
    init() {
        _viewModel = StateObject(wrappedValue: ToDoListViewModel())
        _showPopup = State(initialValue: false)
        _showDeleteAlert = State(initialValue: false)
        print(Date.now)
    }
    
    var body: some View {
        NavigationStack {
//            VStack {
//                List {
//                    if viewModel.toDoTasks.isEmpty {
//                        Spacer()
//                            .listRowSeparator(.hidden)
//                        Text("No Tasks Added")
//                            .font(.largeTitle)
//                            .opacity(0.5)
//                            .listRowSeparator(.hidden)
//                        Spacer()
//                            .listRowSeparator(.hidden)
//                    } else {
//                        Section(header: Text("To do")) {
//                            ForEach(Array(viewModel.toDoTasks.enumerated()), id: \.offset) { index, item in
//                                ItemCardView(item: item,
//                                             itemIds: viewModel.allTasksIds) { newValue in
//                                    viewModel.updateTask(taskId: item.id, isTaskComplete: newValue)
//                                }
//                                
//                            }
//                            .listRowSeparator(.hidden)
//                        }
//                    }
//                    
//                    if !viewModel.completedTasks.isEmpty {
//                        Section(header: Text("Completed")) {
//                            ForEach(Array(viewModel.completedTasks.enumerated()), id: \.offset) { index, item in
//                                ItemCardView(item: item,
//                                             itemIds: viewModel.allTasksIds) { newValue in
//                                    viewModel.updateTask(taskId: item.id, isTaskComplete: newValue)
//                                }
//                                             .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                                                 Button("Delete", systemImage: "trash") {
//                                                     viewModel.delete(taskId: item.id)
//                                                 }
//                                                 .tint(.red)
//                                             }
//                                             .enableScrollViewSwipeAction()
//                            }
//                            .listRowSeparator(.hidden)
//                        }
//                    }
//                }
//                .listStyle(PlainListStyle())
//            }
            ScrollView {
                if viewModel.toDoTasks.isEmpty {
                    Spacer()
                    Text("No Tasks Added")
                        .font(.largeTitle)
                        .opacity(0.5)
                    Spacer()
                } else {
                    Section {
                        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                            ForEach(Array(viewModel.toDoTasks.enumerated()), id: \.offset) { index, item in
                                ItemCardView(item: item,
                                             itemIds: viewModel.allTasksIds) { newValue in
                                    viewModel.updateTask(taskId: item.id, isTaskComplete: newValue)
                                }
                                             .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                                 Button("Delete", systemImage: "trash") {
                                                     showDeleteAlert = true
                                                     viewModel.idToDelete = item.id
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
                                ItemCardView(item: item,
                                             itemIds: viewModel.allTasksIds) { newValue in
                                    viewModel.updateTask(taskId: item.id, isTaskComplete: newValue)
                                }
                                             .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button("Delete", systemImage: "trash") {
                                        showDeleteAlert = true
                                        viewModel.idToDelete = item.id
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
            }.alert(NSLocalizedString("Delete_Alert_Text", comment: ""), isPresented: $showDeleteAlert) {
                Button(NSLocalizedString("Delete_Button_Text", comment: ""), role: .destructive) {
                    viewModel.delete(taskId: viewModel.idToDelete)
                }
                Button(NSLocalizedString("Cancel_Alert_Text", comment: ""), role: .cancel) { }
            }
        }
    }
}
