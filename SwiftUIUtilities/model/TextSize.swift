//
//  TextSize.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/18/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Define custom text size to be used with InterfaceBuilder. Use 
/// @IBInspectable to set this value, and manually parse it to get its 
/// CGFloat value.
public enum TextSize: Int {
    
    // Zero text size.
    case none = 0
    
    // Tiny text size.
    case tiny
    
    // Smallest text size.
    case smallest
    
    // Smaller text size.
    case smaller
    
    // Small text size.
    case small
    
    // Medium text size.
    case medium
    
    // Large text size.
    case large
    
    // Larger text size.
    case larger
    
    // Largest text size.
    case largest
    
    // Huge text size.
    case huge
    
    // Custom text size.
    case custom = -1
}

extension TextSize: SizeRepresentationType {
    public static func from(value: Int) -> SizeRepresentationType? {
        return TextSize(rawValue: value)
    }
    
    /// Return the associated space value in CGFloat.
    public var value: CGFloat? {
        switch self {
        case .none:
            return 0
            
        case .tiny:
            return 6
            
        case .smallest:
            return 8
            
        case .smaller:
            return 10
            
        case .small:
            return 12
            
        case .medium:
            return 14
            
        case .large:
            return 16
            
        case .larger:
            return 18
            
        case .largest:
            return 20
            
        case .huge:
            return 22
            
        case .custom:
            return nil
        }
    }
}
