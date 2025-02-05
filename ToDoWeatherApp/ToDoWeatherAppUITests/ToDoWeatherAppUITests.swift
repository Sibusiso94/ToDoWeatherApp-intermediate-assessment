import XCTest

final class ToDoWeatherAppUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testTabBarComponentsExists() throws {
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssert(tabBar.buttons["To Do"].exists)
        XCTAssert(tabBar.buttons["Weather"].exists)
    }
    
    func testGivenTappingOnAddingIconThenAddViewShows() {
        let element = app.navigationBars[NSLocalizedString("Todo_List_View_Title", comment: "")]
        element.buttons.firstMatch.tap()
        
//        XCTAssert()
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
