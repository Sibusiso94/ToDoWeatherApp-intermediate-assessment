import Foundation
import RealmSwift
import OSLog

class ToDoDataProvider: DataSource {
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
    
    func update(taskId: String, isTasksComplete: Bool) throws {
        let realm = try! Realm()
        
        if let itemToUpdate = realm.object(ofType: ToDoItem.self, forPrimaryKey: taskId) {
            try! realm.write {
                itemToUpdate.isCompleted = isTasksComplete
            }
        }
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
