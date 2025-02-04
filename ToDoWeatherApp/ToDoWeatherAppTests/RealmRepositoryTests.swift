import XCTest
import RealmSwift
@testable import ToDoWeatherApp

final class RealmRepositoryTests: XCTestCase {
    var viewModel: ToDoListViewModel! = nil
    var repository: RealmRepository! = nil
    let config = Realm.Configuration(inMemoryIdentifier: "TestRealm")

    override func setUpWithError() throws {
        super.setUp()
        repository = RealmRepository()
        repository.realm = try! Realm(configuration: config)
        viewModel = ToDoListViewModel()
        
    }

    override func tearDownWithError() throws {
        repository.clearRealm()
        super.tearDown()
    }

    func testAddingFunctionAddsItemsSuccessfully() throws {
        repository.clearRealm()
        viewModel.newItem = ToDoItem(title: "Make food", todoDescription: "Prep pasta and mince and make lasagna")
        
        viewModel.addToDoItem()
        
//        let updatedItem = repository.realm.objects(ToDoItem.self).first
        XCTAssertEqual(viewModel.toDoTasks[0].title, "Make food")
        XCTAssertEqual(viewModel.toDoTasks[0].todoDescription, "Prep pasta and mince and make lasagna")
        XCTAssertEqual(viewModel.allTasksIds[0], viewModel.toDoTasks[0].id)
    }
    
    func testTasksUpdate() throws {
        setUpMockData()
        
        viewModel.updateTask(taskId: "2", isTaskComplete: true)
        
        XCTAssertEqual(viewModel.toDoTasks.count, 0)
        XCTAssertEqual(viewModel.completedTasks.count, 3)
    }
    
    func testItemIdsAreStoredConsistently() throws {
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
        viewModel.allTasks = [ToDoItem(id: "1", title: "H", todoDescription: "W", isCompleted: true),
                              ToDoItem(id: "2", title: "H", todoDescription: "W", isCompleted: false),
                              ToDoItem(id: "3", title: "H", todoDescription: "W", isCompleted: true)]
    }
}
