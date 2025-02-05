import SwiftUI
import Combine
import RealmSwift
import OSLog

enum ToDoListError: Error {
    case failedToLoadData
}

protocol TodoListTaskProvier {
    var allTasks: [ToDoItem] { get set }
    var allTasksIds: [String] { get set }
    var toDoTasks: [ToDoItem] { get set }
    var completedTasks: [ToDoItem] { get set }
    var newItem: ToDoItem { get set }
}

protocol ToDoListDataProvider {
    func fetchItem()
    func persistItem(_ newToDoItem: ToDoItem)
    func completeTask(taskId: String, isTaskComplete: Bool)
    func editTask(taskId: String,
                  title: String?,
                  todoDescription: String?)
    func delete(taskId: String)
}

class ToDoListViewModel: ObservableObject, TodoListTaskProvier, ToDoListDataProvider {
    var dataProvider = ToDoDataProvider()
    
    @Published var allTasks: [ToDoItem] = []
    @Published var allTasksIds: [String] = []
    @Published var toDoTasks: [ToDoItem] = []
    @Published var completedTasks: [ToDoItem] = []
    @Published var newItem = ToDoItem()
    
    @Published var didFail = false
    @Published var didSucceed = false
    @Published var selectedItemId = ""
    @Published var isEditing = false
    
    init() {
        self.fetchItem()
        self.filterTasks()
    }
    
    func fetchItem() {
        allTasks = dataProvider.readAll()
    }
    
    func addToDoItem() {
        let newId = generateNewId()
        var newToDoItem = ToDoItem(id: newId,
                                   todoTitle: newItem.todoTitle,
                                   todoDescription: newItem.todoDescription)
        persistItem(newToDoItem)
        toDoTasks.append(newToDoItem)
        allTasksIds.append(newId)
    }
    
    func persistItem(_ newToDoItem: ToDoItem) {
        do {
            try dataProvider.create(newToDoItem)
            didSucceed = true
        } catch {
            os_log("Failed to create object: %@", type: .debug, error.localizedDescription)
            didFail = true
        }
    }
    
    func completeTask(taskId: String, isTaskComplete: Bool) {
        do {
            try dataProvider.update(taskId: taskId, isTasksComplete: isTaskComplete) {
                self.fetchItem()
                self.filterTasks()
            }
        } catch (let error) {
            os_log("Failed to complete object: %@", type: .debug, error.localizedDescription)
            didFail = true
        }
    }
    
    func editTask(taskId: String,
                  title: String? = nil,
                  todoDescription: String? = nil) {
        let id = taskId
        let editedTitle = title
        let editedToDoDescription = todoDescription
        
        do {
            try dataProvider.update(taskId: id,
                                    title: editedTitle == "" ? nil : editedTitle,
                                    todoDescription: editedToDoDescription == "" ? nil : editedToDoDescription) {
                self.fetchItem()
                self.filterTasks()
                self.didSucceed = true
            }
        } catch {
            os_log("Failed to edit object")
            didFail = true
        }
    }
    
    func delete(taskId: String) {
        do {
            try dataProvider.delete(taskId)
            fetchItem()
            filterTasks()
        } catch let error {
            os_log("Failed to delete object: %@", type: .debug, error.localizedDescription)
            didFail = true
        }
    }
    
    func filterTasks() {
        toDoTasks = allTasks.filter { $0.isCompleted == false }
        completedTasks = allTasks.filter { $0.isCompleted == true }
        getItemIds()
    }
    
    func getItemIds() {
        allTasksIds = allTasks.map { $0.id }
    }
    
    func generateNewId() -> String {
        UUID().uuidString
    }
    
    func clearAddViewText() {
        newItem = ToDoItem()
        isEditing = false
    }
}
