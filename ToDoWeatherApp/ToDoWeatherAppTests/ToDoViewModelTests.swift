import XCTest
import RealmSwift
@testable import ToDoWeatherApp

final class ToDoViewModelTests: XCTestCase {
    let viewModel = ToDoListViewModel()
    var dataProvider: ToDoDataProvider! = nil

    override func setUpWithError() throws {
        super.setUp()
        let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")
        dataProvider = ToDoDataProvider()
        dataProvider.repository.realm = try! Realm(configuration: config)
        viewModel.dataProvider = dataProvider
    }

    override func tearDownWithError() throws {
        viewModel.dataProvider.repository.clearRealm()
        super.tearDown()
    }

    func testGivenAddingDataThenAddsItemsTotoDoTasksSuccessfully() throws {
        viewModel.newItem = ToDoItem(todoTitle: "Make food", todoDescription: "Prep pasta and mince and make lasagna")
        
        self.viewModel.addToDoItem()
        
        XCTAssertEqual(viewModel.toDoTasks[0].todoTitle, "Make food")
        XCTAssertEqual(viewModel.toDoTasks[0].todoDescription, "Prep pasta and mince and make lasagna")
        XCTAssertEqual(viewModel.allTasksIds[0], viewModel.toDoTasks[0].id)
    }
    
    func testGivenTasksIsCompletedThenToDoTaskIsEmpty() throws {
        let expectation = expectation(description: "Complete writing to realm")
        setUpMockData()
        
        self.viewModel.completeTask(taskId: "2", isTaskComplete: true)
        
        XCTAssertEqual(viewModel.toDoTasks.count, 0)
        XCTAssertEqual(viewModel.completedTasks.count, 3)
    }
    
    func testGivenItemsAddedWhenIdsAreSortedThenIdsAppendsToAllTasksIds() throws {
        setUpMockData()
        viewModel.getItemIds()
        
        XCTAssertEqual(viewModel.allTasksIds, ["1","2","3"])
    }
    
    func testTasksGetFilteredCorrectly() throws {
        setUpMockData()
        viewModel.filterTasks()
        
        XCTAssertEqual(viewModel.toDoTasks.count, 1)
        XCTAssertEqual(viewModel.completedTasks.count, 2)
        XCTAssertFalse(viewModel.toDoTasks[0].isCompleted)
        XCTAssertTrue(viewModel.completedTasks[0].isCompleted)
    }
    
    func setUpMockData() {
        viewModel.allTasks = [ToDoItem(id: "1", todoTitle: "H", todoDescription: "W", isCompleted: true),
                              ToDoItem(id: "2", todoTitle: "H", todoDescription: "W", isCompleted: false),
                              ToDoItem(id: "3", todoTitle: "H", todoDescription: "W", isCompleted: true)]
    }
}

class MockTodoDataProvider: DataProvider {
    typealias T = ToDoItem
    
    var repository = RealmRepository()
    let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")
    
    init() {
        self.repository.realm = try! Realm(configuration: config)
    }
    
    func readAll() -> [T] {
        repository.readAll(T.self)
    }
    
    func delete(_ id: String) throws {
        do {
            try repository.delete(id, ofType: T.self)
        } catch {
            print(error)
        }
    }
    
    func create(_ object: T) {
        do {
            try repository.create(object)
        } catch {
            print(error)
        }
    }
}

class MockToDoItem {
    static let item = ToDoItem(todoTitle: "Make food", todoDescription: "Prep pasta and mince and make lasagna")
}
