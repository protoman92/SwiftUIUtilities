//
//  Unidirection.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 31/8/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities

/// This enum represents directions.
///
/// - up: Up direction.
/// - down: Down direction.
/// - left: Left direction.
/// - right: Right direction.
public enum Unidirection: Int {
  case up = -1
  case down = 1
  case left = -2
  case right = 2

  /// Check if the current direction is horizontal.
  ///
  /// - Returns: A Bool value.
  public func isHorizontal() -> Bool {
    switch self {
    case .left, .right:
      return true

    default:
      return false
    }
  }

  /// Check if the current direction is vertical.
  ///
  /// - Returns: A Bool value.
  public func isVertical() -> Bool {
    return !isHorizontal()
  }
}

extension Unidirection: EnumerableType {
  public static func allValues() -> [Unidirection] {
    return [.up, .down, .left, .right]
  }
}
