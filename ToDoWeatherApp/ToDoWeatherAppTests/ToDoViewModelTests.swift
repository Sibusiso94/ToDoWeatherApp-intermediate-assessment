import XCTest
import RealmSwift
@testable import ToDoWeatherApp

final class ToDoViewModelTests: XCTestCase {
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

    func testGivenAddingDataThenAddsItemsTotoDoTasksSuccessfully() throws {
        viewModel.newItem = ToDoItem(title: "Make food", todoDescription: "Prep pasta and mince and make lasagna")
        
        self.viewModel.addToDoItem()
        
        XCTAssertEqual(viewModel.toDoTasks[0].title, "Make food")
        XCTAssertEqual(viewModel.toDoTasks[0].todoDescription, "Prep pasta and mince and make lasagna")
        XCTAssertEqual(viewModel.allTasksIds[0], viewModel.toDoTasks[0].id)
    }
    
    func testGivenTasksIsCompletedThenToDoTaskIsEmpty() throws {
//        let expectation = expectation(description: "Complete writing to realm")
        setUpMockData()
        
//        DispatchQueue.global(qos: .background).async {
            self.viewModel.updateTask(taskId: "2", isTaskComplete: true)
//            expectation.fulfill()
//        }
        
//        wait(for: [expectation], timeout: 5.0)
        
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
        viewModel.allTasks = [ToDoItem(id: "1", title: "H", todoDescription: "W", isCompleted: true),
                              ToDoItem(id: "2", title: "H", todoDescription: "W", isCompleted: false),
                              ToDoItem(id: "3", title: "H", todoDescription: "W", isCompleted: true)]
    }
}
