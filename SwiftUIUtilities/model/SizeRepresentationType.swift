//
//  SizeRepresentationType.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/19/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Enums that represent size/space should implement this protocol.
public protocol SizeRepresentationType {

  /// Return a SizeRepresentationType based on a raw value.
  ///
  /// - Parameter value: An Int value.
  /// - Returns: A SizeRepresentationType instance.
  static func from(value: Int) -> SizeRepresentationType?

  /// Get the associated size.
  var value: CGFloat? { get }
}
