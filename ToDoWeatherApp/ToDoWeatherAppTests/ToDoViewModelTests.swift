import XCTest
import RealmSwift
@testable import ToDoWeatherApp

final class ToDoViewModelTests: XCTestCase {
    var viewModel: ToDoListViewModel! = nil
    var dataProvider: ToDoDataProvider! = nil

    override func setUpWithError() throws {
        super.setUp()
        let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")
        dataProvider = ToDoDataProvider()
        dataProvider.repository.realm = try! Realm(configuration: config)
        viewModel = ToDoListViewModel(dataProvider: dataProvider)
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
        setUpMockData()
        viewModel.fetchItem()
        viewModel.filterTasks()
        
        let incompleteItem = viewModel.toDoTasks.first(where: { $0.isCompleted == false })
        let incompleteId = incompleteItem?.id ?? ""
        
        self.viewModel.completeTask(taskId: incompleteId, isTaskComplete: true)
        viewModel.fetchItem()
        viewModel.filterTasks()
        
        XCTAssertEqual(viewModel.toDoTasks.count, 2)
        XCTAssertEqual(viewModel.completedTasks.count, 1)
    }
    
    func testGivenItemsAddedWhenIdsAreSortedThenIdsAppendsToAllTasksIds() throws {
        setUpMockData()
        viewModel.getItemIds()
        
        XCTAssertEqual(viewModel.allTasksIds, ["1","2","3"])
    }
    
    func testTasksGetFilteredCorrectly() throws {
        setUpMockData()
        viewModel.fetchItem()
        viewModel.filterTasks()
        
        XCTAssertEqual(viewModel.toDoTasks.count, 2)
        XCTAssertEqual(viewModel.completedTasks.count, 1)
    }
    
    func setUpMockData() {
        let allTasks = [ToDoItem(id: "1", todoTitle: "H", todoDescription: "W", isCompleted: true),
                        ToDoItem(id: "2", todoTitle: "H", todoDescription: "W", isCompleted: false),
                        ToDoItem(id: "3", todoTitle: "H", todoDescription: "W", isCompleted: true)]
        
        for task in allTasks {
            viewModel.newItem = task
            viewModel.addToDoItem()
        }
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
