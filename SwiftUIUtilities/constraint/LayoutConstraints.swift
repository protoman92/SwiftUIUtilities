//
//  LayoutConstraints.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/29/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

public extension NSLayoutConstraint {
    
    /// Check if the current constraint is a direct constraint i.e. it can
    /// be added directly to the UIView in question.
    public var isDirectConstraint: Bool {
        return isDimensionConstraint || isAspectRatioConstraint
    }
    
    /// Check if the current constraint is a height or width constraint.
    /// If it is, we should use Size enum to dynamically set its constant
    /// value. Otherwise, we should use Space enum.
    public var isDimensionConstraint: Bool {
        switch true {
            
        // Direct constraints have secondAttribute as .notAnAttribute.
        case secondAttribute != .notAnAttribute:
            return false
            
        case firstAttribute == .width:
            fallthrough
            
        case firstAttribute == .height:
            return true
            
        default:
            break
        }
        
        return false
    }
    
    /// Check if the current constraint is an aspect ratio constraint. Similar
    /// to dimension constraints, we use Size enum.
    public var isAspectRatioConstraint: Bool {
        switch true {
        case secondItem == nil:
            fallthrough
            
        case firstItem as? UIView != secondItem as? UIView:
            return false
            
        case firstAttribute == .width && secondAttribute == .height:
            fallthrough
            
        case firstAttribute == .height && secondAttribute == .width:
            return true
            
        default:
            break
        }
        
        return false
    }
    
    public var sizeRepresentationType: SizeRepresentationType.Type? {
        if isDirectConstraint {
            return Size.self
        } else {
            return Space.self
        }
    }
}

public extension NSLayoutConstraint {
    
    /// Clone a constraint and optionally set properties on the clone to
    /// mimic those of the original.
    ///
    /// - Parameters:
    ///   - constraint: The constraint to clone from.
    ///   - identifier: The constraint identifier.
    ///   - firstItem: The constraint firstItem.
    ///   - firstAttribute: The constraint firstAttribute.
    ///   - secondItem: The constraint secondItem.
    ///   - secondAttribute: The constraint secondAttribute.
    ///   - relation: The constraint relation.
    ///   - constant: The constraint constant.
    ///   - multiplier: The constraint multiplier.
    /// - Returns: A NSLayoutConstraint instance.
    public static func clone(from constraint: NSLayoutConstraint,
                             identifier: String? = nil,
                             firstItem: AnyObject? = nil,
                             firstAttribute: NSLayoutAttribute? = nil,
                             secondItem: AnyObject? = nil,
                             secondAttribute: NSLayoutAttribute? = nil,
                             relation: NSLayoutRelation? = nil,
                             constant: CGFloat? = nil,
                             multiplier: CGFloat? = nil) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: firstItem ?? constraint.firstItem,
            attribute: firstAttribute ?? constraint.firstAttribute,
            relatedBy: relation ?? constraint.relation,
            toItem: secondItem ??  constraint.secondItem,
            attribute: secondAttribute ?? constraint.secondAttribute,
            multiplier: multiplier ?? constraint.multiplier,
            constant: constant ?? constraint.constant
        )
        
        newConstraint.identifier = identifier ?? constraint.identifier
        return newConstraint
    }
    
    // Clone the current constraint and optionally set properties on the
    /// clone to mimic those of the original.
    ///
    /// - Parameters:
    ///   - identifier: The constraint identifier.
    ///   - firstItem: The constraint firstItem.
    ///   - firstAttribute: The constraint firstAttribute.
    ///   - secondItem: The constraint secondItem.
    ///   - secondAttribute: The constraint secondAttribute.
    ///   - relation: The constraint relation.
    ///   - constant: The constraint constant.
    ///   - multiplier: The constraint multiplier.
    /// - Returns: A NSLayoutConstraint instance.
    public func clone(identifier: String? = nil,
                      firstItem: AnyObject? = nil,
                      firstAttribute: NSLayoutAttribute? = nil,
                      secondItem: AnyObject? = nil,
                      secondAttribute: NSLayoutAttribute? = nil,
                      relation: NSLayoutRelation? = nil,
                      constant: CGFloat? = nil,
                      multiplier: CGFloat? = nil) -> NSLayoutConstraint {
        return NSLayoutConstraint.clone(from: self,
                                        identifier: identifier,
                                        firstItem: firstItem,
                                        firstAttribute: firstAttribute,
                                        secondItem: secondItem,
                                        secondAttribute: secondAttribute,
                                        relation: relation,
                                        constant: constant,
                                        multiplier: multiplier)
    }
}
