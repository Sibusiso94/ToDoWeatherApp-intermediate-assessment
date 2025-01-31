import Foundation
import RealmSwift

class Migrator {
    init() {
        updateSchema()
    }
    
    func updateSchema() {
        let config = Realm.Configuration(
            schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
    }
}
