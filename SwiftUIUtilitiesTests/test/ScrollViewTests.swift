//
//  ScrollViewTests.swift
//  SwiftUIUtilitiesTests
//
//  Created by Hai Pham on 9/3/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import RxTest
import SwiftUtilities
import SwiftUtilitiesTests
import XCTest
@testable import SwiftUIUtilities

public final class ScrollViewTests: RootTest {
    var scrollView: UIScrollView!
    
    override public func setUp() {
        super.setUp()
        scrollView = UIScrollView(frame: CGRect.infinite)
    }
    
    public func test_contentSizeObservable_shouldWork() {
        /// Setup
        let observer = scheduler.createObserver(CGSize.self)
        let scrollView = self.scrollView!
        let contentSizeObs = scrollView.rx.contentSize
        let count = iterationCount!
        let testSizes = (0..<count).map({_ in CGSize.random})
        
        /// When
        contentSizeObs.skip(1).subscribe(observer).disposed(by: disposeBag)
        testSizes.forEach({scrollView.contentSize = $0})
        
        /// Then
        let nextElements = observer.nextElements()
        XCTAssertEqual(nextElements.count, testSizes.count)
        XCTAssertTrue(testSizes.all(nextElements.contains))
    }
    
    public func test_contentOffsetChange_shouldWork() {
        /// Setup
        let observer = scheduler.createObserver(CGPoint.self)
        let scrollView = self.scrollView!
        let contentOffsetChangeObs = scrollView.rx.contentOffsetChange
        let count = iterationCount!
        let testOffsets = (0..<count).map({_ in CGPoint.random})
        
        var testChanges = (0..<count - 1).map({
            testOffsets[$0 + 1].difference(from: testOffsets[$0])
        })
        
        // Insert the first element to simulate difference against CGPoint.zero.
        testChanges.insert(testOffsets[0], at: 0)
        
        /// When
        contentOffsetChangeObs.skip(1).subscribe(observer).disposed(by: disposeBag)
        testOffsets.forEach({scrollView.contentOffset = $0})
        
        /// Then
        let nextElements = observer.nextElements()
        XCTAssertEqual(nextElements.count, testChanges.count)
        XCTAssertTrue(nextElements.all(testChanges.contains))
    }
}
