//
//  Duration.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/18/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// This enum is used to specify common durations, such as those used in
/// animations.
public enum Duration: Double {
    /// Very short duration.
    case veryShort = 0.1
    
    /// Short duration. This is the default for visibility animations.
    case short = 0.2
    
    /// Medium duration.
    case medium = 0.5
    
    /// Long duration.
    case long = 1
    
    /// Very long duration.
    case veryLong = 1.5
}
