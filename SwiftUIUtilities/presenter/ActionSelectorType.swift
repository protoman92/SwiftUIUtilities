//
//  ActionSelectorType.swift
//  SwiftPlaceholderTextView
//
//  Created by Hai Pham on 4/18/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Classes that acts as a selector target should implement this protocol.
/// For e.g. BasePresenter subclasses.
@objc public protocol ActionSelectorType {

  /// This method shall be the master method that receives all important
  /// UIView events, such as UIButton's TouchDown. We can insert
  /// analytics-tracking methods here to catch all user interactons.
  ///
  /// - Parameters:
  ///   - sender: The object that was interacted with.
  ///   - event: The interaction event.
  func actionReceived(sender: AnyObject, event: UIEvent)

  /// Override this method to provide specific actions to be taken.
  ///
  /// - Parameters:
  ///   - sender: The object that was interacted with.
  ///   - event: The interaction event.
  func actionExecuted(sender: AnyObject, event: UIEvent)
}
