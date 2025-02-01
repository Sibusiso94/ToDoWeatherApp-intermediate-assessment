import SwiftUI
import Combine
import RealmSwift
import OSLog

class ToDoListViewModel: ObservableObject {
    let dataProvider = ToDoDataProvider()
    
    @Published var allTasks: [ToDoItem] = []
    @Published var toDoTasks: [ToDoItem] = []
    @Published var completedTasks: [ToDoItem] = []
    @Published var newItem = ToDoItem()
    
    @Published var didFail = false
    @Published var didSucceed = false
    
    init() {
        self.fetchItem()
        self.filterTasks()
    }
    
    func fetchItem() {
        allTasks = dataProvider.readAll()
    }
    
    func addToDoItem() {
        var newToDoItem = ToDoItem(id: generateNewId(),
                                   title: newItem.title,
                                   todoDescription: newItem.todoDescription)
        do {
            try dataProvider.create(newToDoItem)
            didSucceed = true
            toDoTasks.append(newToDoItem)
        } catch {
            os_log("Failed to create object: %@", type: .debug, error.localizedDescription)
            didFail = true
        }
    }
    
    func updateTask(taskId: String, isTaskComplete: Bool) {
        do {
            try dataProvider.update(taskId: taskId, isTasksComplete: isTaskComplete)
            fetchItem()
            filterTasks()
        } catch (let error) {
            os_log("Failed to create object: %@", type: .debug, error.localizedDescription)
            didFail = true
        }
    }
    
    func delete(taskId: String) {
        do {
            try dataProvider.delete(taskId)
        } catch let error {
            os_log("Failed to create object: %@", type: .debug, error.localizedDescription)
            didFail = true
        }
    }
    
    func filterTasks() {
        toDoTasks = allTasks.filter { $0.isCompleted == false }
        completedTasks = allTasks.filter { $0.isCompleted == true }
    }
    
    func getItemIds() -> [String] {
        return allTasks.map { $0.id }
    }
    
    func generateNewId() -> String {
        UUID().uuidString
    }
}
