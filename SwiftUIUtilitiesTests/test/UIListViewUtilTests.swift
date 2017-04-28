//
//  UIListViewUtilTests.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/24/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit
import XCTest

class UIListViewUtilTests: XCTestCase {
    func test_cellIdentifier_shouldWorkCorrectly() {
        // Setup
        
        // When
        let identifier1 = Cell1.identifier
        let identifier2 = Cell2.identifier
        
        // Then
        XCTAssertEqual(identifier1, "Cell1")
        XCTAssertEqual(identifier2, "Cell2")
    }
}

class Cell1: UICollectionViewCell {}
class Cell2: UITableViewCell {}
