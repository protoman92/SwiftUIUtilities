//
//  BaseLayoutConstraint.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/19/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import UIKit

/// This class shall use size representation enums for common sizes/spaces.
public final class BaseLayoutConstraint: NSLayoutConstraint {
    @IBInspectable public var constantValue: Int?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        resetConstraint()
    }
    
    /// Reset constant value based on the dynamic constantValue property,
    /// as set in InterfaceBuilder.
    fileprivate func resetConstraint() {
        guard
            let constantValue = self.constantValue,
            let representation = sizeRepresentationType,
            let sizeInstance = representation.from(value: constantValue),
            let newConstant = sizeInstance.value
        else {
            if isInDebugMode() {
                print(self)
                fatalError()
            }
            
            return
        }
        
        constant = (constant < 0 ? -1 : 1) * newConstant
    }
}

public extension NSLayoutConstraint {
    
    /// Check if the current constraint is a height or width constraint. If
    /// it is, we should use Size enum to dynamically set its constant value.
    /// Otherwise, we should use Space enum.
    fileprivate var isHeightOrWidthConstraint: Bool {
        switch true {
            
        // Height/Width constraints have secondAttribute as .notAnAttribute.
        case secondAttribute != .notAnAttribute:
            fallthrough
            
        case firstAttribute != .width && firstAttribute != .height:
            return false
            
        default:
            break
        }
        
        return true
    }
    
    fileprivate var sizeRepresentationType: SizeRepresentationType.Type? {
        if isHeightOrWidthConstraint {
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
}
