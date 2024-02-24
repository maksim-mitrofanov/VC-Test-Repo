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
        
        app.tap()
        
        wait(seconds: 1)
        let mainTableView = app.tables[GlobalNameSpace.vcHomeScreenTableView.rawValue]
        XCTAssertTrue(mainTableView.exists, "The table view exists on the home screen.")

        mainTableView.swipeUp()
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
