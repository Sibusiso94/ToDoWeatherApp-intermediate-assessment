import Foundation
import RealmSwift

protocol DataSource: CreateObject, ReadObject, DeleteObject { }

protocol CreateObject {
    associatedtype T: Object
    func create(_ object: T) throws
}

protocol ReadObject {
    associatedtype T: Object
    func readAll() -> [T]
}

protocol UpdateObject {
    associatedtype T: AnyObject
    func update(_ object: T) throws
}

protocol DeleteObject {
    associatedtype T: Object
    func delete(_ id: String) throws
}

protocol DataTransformable {
    associatedtype T: Object
    func convertListToResult(with results: List<T>) -> [T]
    func mapResults(with results: [T]) -> List<T>
}

public typealias RealmDecodable = Object & Decodable
public typealias RealmCodable = Object & Codable

fileprivate func getConfiguration(fileName: String) -> Realm.Configuration {
    var configuration = Realm.Configuration.defaultConfiguration
    configuration.fileURL = configuration.fileURL?.deletingLastPathComponent().appendingPathComponent(fileName)
    return configuration
}

class RealmRepository {
    var configuration: Realm.Configuration
    private var _realm: Realm?
    
    public init() {
        let configuration = getConfiguration(fileName: "toDoWeatherApp.realm")
        Realm.Configuration.defaultConfiguration = configuration
        
        self.configuration = configuration
        
        initializeRealm()
    }
    
    private func initializeRealm() {
        do {
            _ = try Realm(configuration: configuration)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public var realm: Realm {
        get {
                if _realm == nil {
                    _realm = try! Realm() // Lazily initialize if not set
                }
                return _realm!
            }
            set {
                _realm = newValue
            }
    }
    
    func create(_ insertions: Object) throws {
        try transaction { realm in
            realm.add(insertions)
        }
    }

    public func read<T: Object>(_ type: T.Type) -> T? {
        return readAll(type).first
    }
    
    public func readAll<T: Object>(_ type: T.Type) -> [T] {
        return Array(realm.objects(type))
    }
    
    public func update<T: Object>(_ object: T) throws {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    public func delete<T: Object>(_ id: String, ofType: T.Type) throws {
        let realm = try! Realm()
        
        if let objectToDelete = realm.object(ofType: T.self, forPrimaryKey: id) {
            if !objectToDelete.isInvalidated {
                try! realm.write {
                    realm.delete(objectToDelete)
                }
            }
        } else {
            print("Object not found")
        }
    }
    
    private func transaction(block: ((Realm) throws -> Void)) throws {
        do {
            let realm = self.realm
            realm.beginWrite()
            do {
                try block(realm)
            } catch {
                if realm.isInWriteTransaction {
                    realm.cancelWrite()
                }
                throw error
            }
            if realm.isInWriteTransaction {
                try realm.commitWrite()
            }
        } catch let error {
            print("Transaction error: \(error.localizedDescription)")
            throw error
        }
    }
    
    public func clearRealm() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

