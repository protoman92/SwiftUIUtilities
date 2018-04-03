//
//  ViewBuilderType.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/21/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import UIKit

/// Implement this protocol to configure views added dynamically by
/// ViewBuilderType.
@objc public protocol ViewBuilderConfigType {

  /// Configure the current UIView, after populating it with a
  /// ViewBuilderType.
  ///
  /// - Parameter view: The UIView to be configured.
  func configure(for view: UIView)
}

/// Implement this protocol for convenient dynamic view building.
@objc public protocol ViewBuilderType: ViewBuilderConfigType {

  /// Get an Array of UIView subviews to be added to a UIView.
  /// - Parameter view: The parent UIView instance.
  /// - Returns: An Array of ViewBuilderComponentType.
  func subviews(for view: UIView) -> [UIView]

  /// Get an Array of NSLayoutConstraint to be added to a UIView.
  ///
  /// - Parameter view: The parent UIView instance.
  /// - Returns: An Array of NSLayoutConstraint.
  func constraints(for view: UIView) -> [NSLayoutConstraint]
}

public extension UIView {

  /// Create a UIView instance and configure it using a ViewBuilderType.
  ///
  /// - Parameters:
  ///   - builder: A ViewBuilderType instance.
  public convenience init(with builder: ViewBuilderType) {
    self.init()
    populateSubviews(with: builder)
  }

  /// Populate subviews with a ViewBuilderType and configure it afterwards.
  ///
  /// - Parameter builder: A ViewBuilderType instance.
  public func populateSubviews(with builder: ViewBuilderType) {
    let subviews = builder.subviews(for: self)

    // Set translatesAutoresizingMaskIntoConstraints to false to avoid
    // unwanted constraints.
    subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})

    // We first add all subviews.
    subviews.forEach(addSubview)

    /// We create the constraints after adding all subviews in order to
    /// access all available subviews.
    let constraints = builder.constraints(for: self)

    // Then we add the layout constraints. Direct constraints will be
    // added to the constraint's firstItem (provided it is a UIView).
    for cs in constraints {
      if cs.isDirectConstraint, let view = cs.firstItem as? UIView {
        view.addConstraint(cs)
      } else {
        addConstraint(cs)
      }
    }

    builder.configure(for: self)
  }
}
