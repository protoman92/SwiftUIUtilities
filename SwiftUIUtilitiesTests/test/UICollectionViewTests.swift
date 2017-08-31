//
//  UICollectionViewTests.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/25/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import XCTest
import UIKit

class UICollectionViewTests: XCTestCase {
    func test_reusableViewKind_shouldReturnCorrectRawValue() {
        // Setup
        
        // When
        let s1 = ReusableViewKind.footer.value
        let s2 = ReusableViewKind.header.value
        let kind1 = ReusableViewKind(from: s1)
        let kind2 = ReusableViewKind(from: s2)
        
        // Then
        XCTAssertEqual(kind1?.value, s1)
        XCTAssertEqual(kind2?.value, s2)
    }
}
