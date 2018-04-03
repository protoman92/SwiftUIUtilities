//
//  Model.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/18/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Define custom space to be used with InterfaceBuilder. Use @IBInspectable
/// to set this value, and manually parse it to get its CGFloat value.
public enum Space: Int {

  // Zero space
  case none = 0

  // Tiny space. Usually used for collectionView line spacing.
  case tiny

  // Smallest space.
  case smallest

  // Smaller space.
  case smaller

  // Small space.
  case small

  // Medium space.
  case medium

  // Large space. Usually used for spacing relative to parent UIView.
  case large

  // Larger space.
  case larger

  // Largest space.
  case largest

  // Huge space.
  case huge

  // Custom space. This will not be translated to CGFloat, i.e. retain the
  // original InterfaceBuilder value.
  case custom = -1
}

extension Space: SizeRepresentationType {
  public static func from(value: Int) -> SizeRepresentationType? {
    return Space(rawValue: value)
  }

  /// Return the associated space value in CGFloat.
  public var value: CGFloat? {
    switch self {
    case .none:
      return 0

    case .tiny:
      return 1

    case .smallest:
      return 2

    case .smaller:
      return 3

    case .small:
      return 5

    case .medium:
      return 10

    case .large:
      return 15

    case .larger:
      return 20

    case .largest:
      return 25

    case .huge:
      return 30

    case .custom:
      return nil
    }
  }
}
