//
//  ConstraintSetType.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/21/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import UIKit

/// Implement this protocol to provide a set of NSLayoutConstraints.
public protocol ConstraintSetType {
    var constraints: [NSLayoutConstraint] { get }
}

extension UIView: ConstraintSetType {}

/// Provide a set of fit constraints i.e. left/top/bottom/right relative to
/// a parent view.
public struct FitConstraintSet {
    
    /// The UIView to which the constraints are to be added.
    fileprivate var parent, child: UIView?
    
    /// Select the constraints to provide.
    fileprivate var addLeft, addTop, addRight, addBottom: Bool
    
    /// Provide margins to use in conjunction with above variables.
    fileprivate var leftMargin, topMargin, rightMargin, bottomMargin: CGFloat
    
    fileprivate init() {
        addLeft = true
        addTop = true
        addRight = true
        addBottom = true
        leftMargin = 0
        topMargin = 0
        rightMargin = 0
        bottomMargin = 0
    }
    
    /// Builder class for FitConstraintSet.
    public final class Builder {
        fileprivate var set: FitConstraintSet
        
        fileprivate init() {
            set = FitConstraintSet()
        }
        
        /// Set the parent view instance.
        ///
        /// - Parameter parent: A UIView instance.
        /// - Returns: The current Builder instance.
        public func with(parent: UIView) -> Builder {
            set.parent = parent
            return self
        }
        
        /// Set the child view instance.
        ///
        /// - Parameter child: A UIView instance.
        /// - Returns: The current Builder instance.
        public func with(child: UIView) -> Builder {
            set.child = child
            return self
        }
        
        /// Add left constraint.
        ///
        /// - Parameters:
        ///   - left: A Bool value.
        ///   - margin: An optional CGFloat value.
        /// - Returns: The current Builder instance.
        public func add(left: Bool,
                        withMargin margin: CGFloat? = nil) -> Builder {
            set.addLeft = left
            set.leftMargin = margin ?? 0
            return self
        }
        
        /// Add right constraint.
        ///
        /// - Parameters:
        ///   - right: A Bool value.
        ///   - margin: An optional CGFloat value.
        /// - Returns: The current Builder instance.
        public func add(right: Bool,
                        withMargin margin: CGFloat? = nil) -> Builder {
            set.addRight = right
            set.rightMargin = margin ?? 0
            return self
        }
        
        /// Add top constraint.
        ///
        /// - Parameters:
        ///   - top: A Bool value.
        ///   - margin: An optional CGFloat value.
        /// - Returns: The current Builder instance.
        public func add(top: Bool,
                        withMargin margin: CGFloat? = nil) -> Builder {
            set.addTop = top
            set.topMargin = margin ?? 0
            return self
        }
        
        /// Add bottom constraint.
        ///
        /// - Parameters:
        ///   - bottom: A Bool value.
        ///   - margin: An optional CGFloat value.
        /// - Returns: The current Builder instance.
        public func add(bottom: Bool,
                        withMargin margin: CGFloat? = nil) -> Builder {
            set.addBottom = bottom
            set.bottomMargin = margin ?? 0
            return self
        }
        
        public func build() -> FitConstraintSet {
            return set
        }
    }
}

public extension FitConstraintSet {
    public static func builder() -> Builder {
        return Builder()
    }
    
    /// Get a FitConstraintSet instance that fits a child UIView to a parent
    /// UIView (no margins).
    ///
    /// - Parameters:
    ///   - parent: The parent UIView.
    ///   - child: The child UIView.
    /// - Returns: A FitConstraintSet instance.
    public static func fit(forParent parent: UIView, andChild child: UIView)
        -> FitConstraintSet
    {
        return FitConstraintSet.builder()
            .with(parent: parent)
            .with(child: child)
            .add(top: true)
            .add(left: true)
            .add(right: true)
            .add(bottom: true)
            .build()
    }
}

extension FitConstraintSet: ConstraintSetType {
    public var constraints: [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        guard let parent = self.parent, let child = self.child else {
            debugException()
            return constraints
        }
        
        if addLeft {
            constraints.append(
                NSLayoutConstraint(item: child,
                                   attribute: .left,
                                   relatedBy: .equal,
                                   toItem: parent,
                                   attribute: .left,
                                   multiplier: 1,
                                   constant: leftMargin)
            )
        }
        
        if addTop {
            constraints.append(
                NSLayoutConstraint(item: child,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: parent,
                                   attribute: .top,
                                   multiplier: 1,
                                   constant: topMargin)
            )
        }
        
        if addBottom {
            constraints.append(
                NSLayoutConstraint(item: parent,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: child,
                                   attribute: .bottom,
                                   multiplier: 1,
                                   constant: bottomMargin)
            )
        }
        
        if addRight {
            constraints.append(
                NSLayoutConstraint(item: parent,
                                   attribute: .right,
                                   relatedBy: .equal,
                                   toItem: child,
                                   attribute: .right,
                                   multiplier: 1,
                                   constant: rightMargin)
            )
        }
        
        return constraints
    }
}

public extension UIView {
    
    /// Add all constraints from a ConstraintSetType.
    ///
    /// - Parameter set: A ConstraintSetType instance.
    public func addConstraints(from set: ConstraintSetType) {
        addConstraints(set.constraints)
    }
    
    /// Add constraints to fit.
    ///
    /// - Parameter child: A UIView instance being added to this UIView.
    public func addFitConstraints(for child: UIView) {
        let set = FitConstraintSet.fit(forParent: self, andChild: child)
        addConstraints(from: set)
    }
}
