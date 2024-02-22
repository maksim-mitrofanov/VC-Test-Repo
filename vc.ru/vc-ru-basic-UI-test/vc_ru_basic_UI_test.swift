//
//  vc_ru_basic_UI_test.swift
//  vc-ru-basic-UI-test
//
//  Created by Максим Митрофанов on 18.02.2024.
//

import XCTest

final class vc_ru_basic_UI_test: XCTestCase {
    
    func testTableViewPerformance() throws {
        let app = XCUIApplication()
        app.launch()
        
        wait(seconds: 1)
       
        let mainTableView = app.tables[GlobalNameSpace.vcHomeScreenTableView.rawValue]
        XCTAssertTrue(mainTableView.exists, "The table view exists on the home screen.")

        for _ in 0...10 {
            app.customSwipeUp()
        }
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        wait(seconds: 1)
        
        let mainTableView = app.tables[GlobalNameSpace.vcHomeScreenTableView.rawValue]
        XCTAssertTrue(mainTableView.exists, "The table view exists on the home screen.")
        
        wait(seconds: 1)
        let firstCell = mainTableView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists, "The first cell in the table view exists")
        
        let imageView = firstCell.images[GlobalNameSpace.vcImageView.rawValue]
        XCTAssertTrue(imageView.exists, "The image view inside the first cell exists")
        
        imageView.tap()
    }
}

extension XCTestCase {
    func wait(seconds: Double) {
        let _ = XCTWaiter.wait(for: [expectation(description: "")], timeout: seconds)
    }
}

extension XCUIElement {
    /// Performs a custom swipe up action.
    func customSwipeUp() {
        let startPoint = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))
        let endPoint = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.01))
        startPoint.press(forDuration: 0.001, thenDragTo: endPoint, withVelocity: .fast, thenHoldForDuration: 0.001)
    }
}
