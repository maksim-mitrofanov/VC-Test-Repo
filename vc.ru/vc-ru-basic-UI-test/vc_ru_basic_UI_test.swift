//
//  vc_ru_basic_UI_test.swift
//  vc-ru-basic-UI-test
//
//  Created by Максим Митрофанов on 18.02.2024.
//

import XCTest

final class vc_ru_basic_UI_test: XCTestCase {

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let _ = XCTWaiter.wait(for: [expectation(description: "Wait for 5 seconds")], timeout: 1.0)
        app.swipeUp()
        let _ = XCTWaiter.wait(for: [expectation(description: "Wait for 5 seconds")], timeout: 1.0)
        app.swipeUp()
        let _ = XCTWaiter.wait(for: [expectation(description: "Wait for 5 seconds")], timeout: 1.0)
        app.swipeUp()
    }
}
