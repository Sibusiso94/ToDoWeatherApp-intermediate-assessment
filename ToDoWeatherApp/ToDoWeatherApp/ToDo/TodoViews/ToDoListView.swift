import SwiftUI

struct ToDoListView: View {
    @StateObject var viewModel: ToDoListViewModel
    @State var showPopup: Bool
    @State var showDeleteAlert: Bool
    
    init() {
        _viewModel = StateObject(wrappedValue: ToDoListViewModel())
        _showPopup = State(initialValue: false)
        _showDeleteAlert = State(initialValue: false)
        print(Date.now)
    }
    
    var body: some View {
        NavigationStack {
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
                                withAnimation {
                                    ItemCardView(item: item,
                                                 itemIds: viewModel.allTasksIds) { newValue in
                                        viewModel.completeTask(taskId: item.id, isTaskComplete: newValue)
                                    }
                                                 .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                                     SwipeActionButton {
                                                         showDeleteAlert = true
                                                         viewModel.selectedItemId = item.id
                                                     } editAction: {
                                                         viewModel.selectedItemId = item.id
                                                         viewModel.isEditing = true
                                                         showPopup = true
                                                     }

                                                 }
                                                 .enableScrollViewSwipeAction()
                                }
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
                                withAnimation {
                                    ItemCardView(item: item,
                                                 itemIds: viewModel.allTasksIds) { newValue in
                                        viewModel.completeTask(taskId: item.id, isTaskComplete: newValue)
                                    }
                                                 .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                                     SwipeActionButton {
                                                         showDeleteAlert = true
                                                         viewModel.selectedItemId = item.id
                                                     } editAction: {
                                                         viewModel.selectedItemId = item.id
                                                         viewModel.isEditing = true
                                                         showPopup = true
                                                     }

                                                 }
                                                 .enableScrollViewSwipeAction()
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
                AddTaskView(titleInput: $viewModel.newItem.todoTitle,
                            descriptionInput: $viewModel.newItem.todoDescription,
                            isEditing: viewModel.isEditing) {
                    if viewModel.isEditing {
                        viewModel.editTask(taskId: viewModel.selectedItemId,
                                           title: viewModel.newItem.todoTitle,
                                           todoDescription: viewModel.newItem.todoDescription)
                    } else {
                        viewModel.addToDoItem()
                    }
                }
                            .alert(viewModel.isEditing ? NSLocalizedString("Item_Edited_Alert_Text", comment: "") : NSLocalizedString("Item_Added_Alert_Text", comment: ""), isPresented: $viewModel.didSucceed) {
                    Button("OK", role: .cancel) { }
                }
                .onDisappear() {
                    viewModel.clearAddViewText()
                }
            }.alert(NSLocalizedString("Delete_Alert_Text", comment: ""), isPresented: $showDeleteAlert) {
                Button(NSLocalizedString("Delete_Button_Text", comment: ""), role: .destructive) {
                    viewModel.delete(taskId: viewModel.selectedItemId)
                }
                Button(NSLocalizedString("Cancel_Alert_Text", comment: ""), role: .cancel) { }
            }
        }
        .navigationTitle(NSLocalizedString("Todo_List_View_Title", comment: ""))
    }
}
