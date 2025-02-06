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
    
    func testGivenTasksAreFetchedAndFilteredWhenIsCompletedThenToDoTaskIsEmpty() throws {
        setUpMockData()
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
        let ids = viewModel.toDoTasks.map({ $0.id })
        
        XCTAssertEqual(viewModel.allTasksIds, ids)
    }
    
    func testTasksGetFilteredCorrectly() throws {
        setUpMockData()
        viewModel.filterTasks()
        
        let itemToUpdate = viewModel.allTasks.first(where: { $0.todoTitle == "Eat" })!
        
        viewModel.completeTask(taskId: itemToUpdate.id, isTaskComplete: true)
        
        XCTAssertEqual(viewModel.toDoTasks.count, 2)
        XCTAssertEqual(viewModel.completedTasks.count, 1)
    }
    
    func testGivenTasksAddedWhenTaskEditedThenTaskIsUpdated() throws {
        setUpMockData()
        let itemToUpdate = viewModel.allTasks.first(where: { $0.todoTitle == "Eat" })!
        
        viewModel.editTask(taskId: itemToUpdate.id, todoDescription: "Order Pizza. I'm too lazy to cook")
        let updatedItem = viewModel.allTasks.first(where: { $0.todoTitle == "Eat" })!
        XCTAssertEqual(updatedItem.todoDescription, "Order Pizza. I'm too lazy to cook")
    }
    
//    func testGivenTasksAddedWhenTaskIsDeletedThenItemNoLongerExists() throws {
//        setUpMockData()
//        let itemTDelete = viewModel.allTasks.first(where: { $0.todoTitle == "Clean" })!
//        
//        viewModel.delete(taskId: itemTDelete.id)
//        XCTAssertEqual(viewModel.allTasks.count, 2)
//        
//    }
    
    func setUpMockData() {
        let allTasks = [ToDoItem(id: "1", todoTitle: "Make food", todoDescription: "Prep pasta and mince and make lasagna", isCompleted: true),
                        ToDoItem(id: "2", todoTitle: "Clean", todoDescription: "Clean kicthen", isCompleted: false),
                        ToDoItem(id: "3", todoTitle: "Eat", todoDescription: "Sit donw and eat", isCompleted: true)]
        
        for task in allTasks {
            viewModel.newItem = task
            viewModel.addToDoItem()
        }
        
        viewModel.fetchItem()
        viewModel.getItemIds()
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
