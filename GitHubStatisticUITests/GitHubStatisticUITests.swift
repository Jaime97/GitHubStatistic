//
//  GitHubStatisticUITests.swift
//  GitHubStatisticUITests
//
//  Created by Jaime Alcántara on 05/04/2021.
//

import XCTest

class GitHubStatisticUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        self.app = XCUIApplication()
        self.app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearch() {
        self.app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).swipeUp()
        
        let searchButton = self.app.buttons["search button"]
        XCTAssertTrue(searchButton.exists)
        searchButton.tap()
        XCTAssertFalse(searchButton.exists)
        self.app.textFields["Search your repository here"].tap()

        self.app.keys["e"].tap()
        self.app.keys["x"].tap()
        self.app.keys["a"].tap()
        self.app.keys["m"].tap()
        self.app.keys["p"].tap()
        self.app.keys["l"].tap()
        self.app.keys["e"].tap()
        self.app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"buscar\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        let cell = self.app.tables/*@START_MENU_TOKEN@*/.staticTexts["golang"]/*[[".cells.staticTexts[\"golang\"]",".staticTexts[\"golang\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: cell, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
                
    }
}
