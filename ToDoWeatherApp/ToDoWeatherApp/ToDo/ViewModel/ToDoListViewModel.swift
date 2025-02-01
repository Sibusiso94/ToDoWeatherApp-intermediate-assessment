import SwiftUI
import Combine
import RealmSwift

class ToDoListViewModel: ObservableObject {
    let dataProvider = ToDoDataProvider()
    
    @Published var allTasks: [ToDoItem] = []
    @Published var toDoTasks: [ToDoItem] = []
    @Published var completedTasks: [ToDoItem] = []
    @Published var newItem = ToDoItem()
    
    @Published var didFail = false
    @Published var didSucceed = false
    
//    private var cancellables = Set<AnyCancellable>()
//    private var toDoResults: Results<ToDoItem>
    
    init() {
        self.fetchItem()
        self.filterTasks()
//        self.observeRealmChanges()
    }

//    private func observeRealmChanges() {
//        // Use Realm's Combine publisher
//        let cancellable = toDoResults
//            .collectionPublisher
//            .freeze()
//            .receive(on: DispatchQueue.main)  // Receive updates on the main thread
//            .sink(receiveCompletion: { completion in
//                if case let .failure(error) = completion {
//                    print("Realm error: \(error.localizedDescription)")
//                }
//            }, receiveValue: { [weak self] tasks in
//                self?.toDoTasks = Array(tasks)  // Trigger SwiftUI UI updates
//            })
//            .store(in: &cancellables)
//    
//    }
    
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
            didFail = true
        }
    }
    
    func updateTask(taskId: String, isTaskComplete: Bool) {
        do {
            try dataProvider.update(taskId: taskId, isTasksComplete: isTaskComplete)
            fetchItem()
            filterTasks()
        } catch (let error) {
            
        }
    }
    
//    func delete() {
//        do {
//            try dataProvider.delete(id, ofType: T.self)
//        } catch let error {
//            
//        }
//    }
    
    func filterTasks() {
        toDoTasks = allTasks.filter { $0.isCompleted == false }
        completedTasks = allTasks.filter { $0.isCompleted == true }
    }
    
    func generateNewId() -> String {
        UUID().uuidString
    }
}
