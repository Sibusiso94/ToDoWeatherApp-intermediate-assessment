import XCTest
import RealmSwift
@testable import ToDoWeatherApp

final class RealmRepositoryTests: XCTestCase {
    var viewModel: ToDoListViewModel! = nil
//    var repository: RealmRepository! = nil

    override func setUpWithError() throws {
        super.setUp()
//        let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")
//        repository = RealmRepository()
//        repository.realm = try! Realm(configuration: config)
//        viewModel = ToDoListViewModel()
        
    }

    override func tearDownWithError() throws {
//        viewModel.repository.clearRealm()
        super.tearDown()
    }

    func testAddingFunctionAddsItemsSuccessfully() throws {
        viewModel.newItem = ToDoItem(title: "Make food", todoDescription: "Prep pasta and mince and make lasagna")
        
        viewModel.addToDoItem()
        
//        let updatedItem = repository.realm.objects(ToDoItem.self).first
        XCTAssertEqual(viewModel.newItem.title, "Make food")
        XCTAssertEqual(viewModel.newItem.todoDescription, "Prep pasta and mince and make lasagna")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
