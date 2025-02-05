import Foundation
import RealmSwift

class Migrator {
    init() {
        updateSchema()
    }
    
    func updateSchema() {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldVersion in
                if oldVersion < 2 {
                    migration.enumerateObjects(ofType: ToDoItem.className()) { oldObject, newObject in
                        newObject?["todoTitle"] = oldObject?["title"]
                    }
                }
            })
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
    }
}
