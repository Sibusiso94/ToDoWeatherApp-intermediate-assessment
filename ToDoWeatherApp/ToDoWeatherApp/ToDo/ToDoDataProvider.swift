import Foundation
import RealmSwift
import OSLog

class ToDoDataProvider: DataProvider {
    let repository = RealmRepository()
    
    typealias T = ToDoItem
    
    func readAll() -> [ToDoItem] {
        return repository.readAll(T.self)
    }
    
    func create(_ object: ToDoItem) throws {
        do {
            try repository.create(object)
        } catch (let error) {
            os_log("Failed to create object: %@", type: .debug, error.localizedDescription)
        }
    }
    
    func update(taskId: String, isTasksComplete: Bool, completion: @escaping () -> Void) throws {
        if let itemToUpdate = repository.realm.object(ofType: ToDoItem.self, forPrimaryKey: taskId) {
            try! repository.realm.write {
                itemToUpdate.isCompleted = isTasksComplete
                completion()
            }
            completion()
        }
    }
    
    func update(taskId: String,
                title: String?,
                todoDescription: String?,
                completion: @escaping () -> Void) throws {
        if let itemToUpdate = repository.realm.object(ofType: ToDoItem.self, forPrimaryKey: taskId) {
            try! repository.realm.write {
                if let title = title {
                    itemToUpdate.todoTitle = title
                }
                
                if let todoDescription {
                    itemToUpdate.todoDescription = todoDescription
                }
                
                completion()
            }
        }
        completion()
    }
    
    func delete(_ id: String) throws {
        do {
            try repository.delete(id, ofType: T.self)
        } catch (let error) {
            
        }
    }
    
    func convertListToResult(with results: List<T>) -> [T] {
        var data = [T]()
        
        for result in results {
            data.append(result)
        }
        
        return data
    }
    
    func mapResults(with results: [T]) -> List<T> {
        let data = List<T>()
        
        for result in results {
            data.append(result)
        }
        
        return data
    }
    
}
