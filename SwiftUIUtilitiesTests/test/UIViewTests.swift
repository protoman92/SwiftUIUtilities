//
//  UIViewTests.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 5/3/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import XCTest

class UIViewUtilTests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func test_superviewWithCondition_shouldWork() {
        let tries = 1000
        let viewCount = 100
        
        for _ in 0..<tries {
            // Setup
            let views = Array(repeating: {(index) -> UIView in
                let view = UIView()
                view.tag = index + 1
                return view
            }, for: viewCount)
            
            for (index, view) in views.enumerated() {
                if let next = views.element(at: index + 1) {
                    view.addSubview(next)
                }
            }
            
            let tag = Int.randomBetween(1, viewCount)
            let last = views.last!
        
            // When
            let superview = last.superview(satisfying: {$0.tag == tag})
        
            // Then
            XCTAssertNotNil(superview)
            XCTAssertEqual(superview!.tag, tag)
        }
    }
}
