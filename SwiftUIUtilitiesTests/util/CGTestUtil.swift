//
//  CGTestUtil.swift
//  SwiftUIUtilitiesTests
//
//  Created by Hai Pham on 9/3/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

@testable import SwiftUIUtilities

public extension CGSize {
  public static var random: CGSize {
    return CGSize(width: CGFloat(Int.random(0, 10000)),
                  height: CGFloat(Int.random(0, 10000)))
  }
}

public extension CGPoint {
  public static var random: CGPoint {
    return CGPoint(x: CGFloat(Int.random(0, 10000)),
                   y: CGFloat(Int.random(0, 10000)))
  }
}
