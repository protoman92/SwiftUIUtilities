//
//  RootTest.swift
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

public class RootTest: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var iterationCount: Int!
    
    override public func setUp() {
        super.setUp()
        continueAfterFailure = false
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        iterationCount = 1000
    }
}
