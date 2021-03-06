//
//  Views.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/17/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import UIKit

/// Catch-all completion closure for animations.
public typealias AnimationComplete = (Bool) -> Void

public extension UIView {

  /// Get all subviews for the current UIView. This method will be
  /// recursively called until the UIViews at the bottom of the hierarchy
  /// are reached.
  public var allSubviews: [UIView] {
    var subviewSet = Set<UIView>()
    allSubviews(forEach: {subviewSet.insert($0)})
    return subviewSet.map({$0})
  }

  /// Get the rootView of the current view hierarchy. For example, in a
  /// UIViewController, the rootView is the controller's master UIView.
  public var rootView: UIView {
    var rootView = self

    while let view = rootView.superview {
      rootView = view
    }

    return rootView
  }

  /// Traverse up the view hierarchy to find the superview that satisfies
  /// a certain condition. Returns nil if none is found.
  ///
  /// - Parameter condition: Closure predicate.
  /// - Returns: An optional UIView instance.
  public func superview(satisfying condition: (UIView) -> Bool) -> UIView? {
    if condition(self) {
      return self
    } else {
      return superview?.superview(satisfying: condition)
    }
  }

  /// Call a method on all of the current UIView's subviews. This method
  /// will be recursively called until the UIViews at the bottom of the
  /// hierarchy are reached.
  ///
  /// - Parameter action: Closure that will take each subview as a parameter.
  public func allSubviews(forEach action: (UIView) -> Void) {
    subviews.forEach({
      action($0)
      $0.allSubviews(forEach: action)
    })
  }

  /// Get all subviews of a certain type. This method is called recursively,
  /// so performance may be an issue.
  ///
  /// - Parameter type: The type to be checked.
  /// - Returns: An Array of UIView instances that satisfy the condition.
  public func allSubviews<T>(ofType type: T.Type) -> [T] {
    return allSubviews.flatMap({$0 as? T})
  }

  /// Get a subview that has a certain accessibilityIdentifier.
  ///
  /// - Parameter id: A String value.
  /// - Returns: An optional UIView instance.
  public func subview(withAccessibilityId id: String) -> UIView? {
    return subviews.filter({$0.accessibilityIdentifier == id}).first
  }
}

public extension UIView {

  /// Get subviews of a certain type.
  ///
  /// - Parameter type: The type to be checked.
  /// - Returns: An Array of UIView instances that satisfy the condition.
  public func subviews<T>(ofType type: T.Type) -> [T] {
    return subviews.flatMap({$0 as? T})
  }

  /// Get the first subview that is of a certain type.
  ///
  /// - Parameter type: The type to be checked.
  /// - Returns: An optional UIView that satisfies the condition.
  public func firstSubview<T>(ofType type: T.Type) -> T? {
    for view in subviews {
      if view is T {
        return view as? T
      } else if let child = view.firstSubview(ofType: type) {
        return child
      }
    }

    return nil
  }
}

public extension UIView {

  /// Get the current UIView's height constraint.
  public var heightConstraint: NSLayoutConstraint? {
    return constraints.filter({
      $0.firstItem as? UIView == self &&
        $0.firstAttribute == .height &&
        $0.secondAttribute == .notAnAttribute
    }).first
  }

  /// Get the current UIView's width constraint.
  public var widthConstraint: NSLayoutConstraint? {
    return constraints.filter({
      $0.firstItem as? UIView == self &&
        $0.firstAttribute == .width &&
        $0.secondAttribute == .notAnAttribute
    }).first
  }

  /// Get the first constraint with a specified identifier.
  ///
  /// - Parameter identifier: A String value.
  /// - Returns: A NSLayoutConstraint instance.
  public func firstConstraint(withIdentifier identifier: String)
    -> NSLayoutConstraint?
  {
    return constraints.filter({$0.identifier == identifier}).first
  }
}

public extension UIView {

  /// Initialize a UIView with a Nib file. We can either specify the file
  /// name, or leave it as default, after which the class name will be
  /// used to look for the file.
  ///
  /// - Parameters:
  ///   - named: The Nib name String.
  ///   - index: An Int value.
  public func initializeWithNib(_ named: String? = nil, _ index: Int = 0) {
    let cls: AnyClass = classForCoder
    let nibName = named ?? String(describing: cls)

    guard
      subviews.count == 0,
      let view = UINib
        .init(nibName: nibName, bundle: Bundle(for: cls))
        .instantiate(withOwner: self, options: nil).element(at: index)
        as? UIView
      else {
        return
    }

    view.frame = bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(view)
  }
}

public extension UIView {

  /// Toggle visibility for the current UIView instance, by animation its
  /// alpha property to the appropriate values, and setting isHidden to
  /// true/false at the right time.
  ///
  /// - Parameters:
  ///   - visible: A Bool value.
  ///   - duration: An optional TimeInstance value.
  ///   - complete: Completion closure.
  public func toggleVisible(toBe visible: Bool,
                            withDuration duration: TimeInterval?,
                            then complete: AnimationComplete?) {
    let duration = duration ?? Duration.short.rawValue

    if visible { isHidden = false }

    UIView.animate(
      withDuration: duration,
      animations: {self.alpha = visible ? 1 : 0}
    ) {
      if !visible { self.isHidden = true }
      complete?($0)
    }
  }
}

public extension UIView {

  /// Replace one NSLayoutConstraint with another.
  ///
  /// - Parameters:
  ///   - constraint: The constraint to be replaced.
  ///   - another: The constraint that will be inserted.
  public func replaceConstraint(_ constraint: NSLayoutConstraint,
                                with another: NSLayoutConstraint) {
    removeConstraint(constraint)
    addConstraint(another)
  }
}

public extension UIView {

  /// Take a snapshop within a CGRect and produce a UIImage.
  ///
  /// - Parameter frame: The CGRect within which the image is to be taken.
  /// - Returns: An optional UIImage instance.
  public func takeSnapshot(within frame: CGRect? = nil) -> UIImage? {
    defer {
      UIGraphicsEndImageContext()
    }

    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }

    let frame = frame ?? self.frame
    UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
    context.translateBy(x: frame.origin.x * -1, y: frame.origin.y * -1)
    self.layer.render(in: context)
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}

public extension Sequence where Iterator.Element: UIView {

  /// Get all subviews that have a certain accessibility identifier.
  ///
  /// - Parameter id: A String value.
  /// - Returns: An Array of UIView.
  public func subviews(withAccessibilityId id: String) -> [UIView] {
    return flatMap({$0.subview(withAccessibilityId: id)})
  }
}
