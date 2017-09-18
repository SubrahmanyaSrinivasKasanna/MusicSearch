//
//  MusicSearchUITests.swift
//  MusicSearchUITests
//
//  Created by Srinivas Kasanna on 9/17/17.
//  Copyright © 2017 asdf. All rights reserved.
//

import XCTest

class MusicSearchUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        
        let app = XCUIApplication()
        let trackNameSearchField = app.searchFields["Track Name"]
        trackNameSearchField.tap()
        trackNameSearchField.typeText("tom waits")
        app.buttons["Search"].tap()
        sleep(2)
        app.tables.cells.containing(.staticText, identifier:"Hold On").staticTexts["Tom Waits"].tap()
        app.navigationBars["Mule Variations"].buttons[" "].tap()
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
