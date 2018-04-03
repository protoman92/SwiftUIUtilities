//
//  Size.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/19/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Define custom size to be used with InterfaceBuilder. Use @IBInspectable
/// to set this value, and manually parse it to get its CGFloat value.
public enum Size: Int {

  // Zero size
  case none = 0

  // Tiny size.
  case tiny

  // Smallest size.
  case smallest

  // Smaller size.
  case smaller

  // Small size.
  case small

  // Medium size.
  case medium

  // Large size.
  case large

  // Larger size.
  case larger

  // Largest size.
  case largest

  // Huge size.
  case huge

  // Custom size. This will not be translated to CGFloat, i.e. retain the
  // original InterfaceBuilder value.
  case custom = -1
}

extension Size: SizeRepresentationType {
  public static func from(value: Int) -> SizeRepresentationType? {
    return Size(rawValue: value)
  }

  /// Return the associated size value in CGFloat.
  public var value: CGFloat? {
    switch self {
    case .none:
      return 0

    case .tiny:
      return 5

    case .smallest:
      return 10

    case .smaller:
      return 20

    case .small:
      return 32

    case .medium:
      return 44

    case .large:
      return 60

    case .larger:
      return 75

    case .largest:
      return 100

    case .huge:
      return 130

    case .custom:
      return nil
    }
  }
}
