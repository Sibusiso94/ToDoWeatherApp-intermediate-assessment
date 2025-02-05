import Foundation
import RealmSwift

class ToDoItem: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var todoTitle: String
    @Persisted var todoDescription: String
    @Persisted var isCompleted: Bool
    
    convenience init(id: String = UUID().uuidString,
                     todoTitle: String,
                     todoDescription: String,
                     isCompleted: Bool = false) {
        self.init()
        self.id = id
        self.todoTitle = todoTitle
        self.todoDescription = todoDescription
        self.isCompleted = isCompleted
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
}
