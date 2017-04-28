//
//  OrientationDetectorType.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/27/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import UIKit

/// Basic orientation types for simple orientations.
///
/// - portrait: Portrait orientation.
/// - landscape: Landscape orientation.
@objc public enum BasicOrientation: Int {
    case portrait = 1
    case landscape
    
    public init(size: CGSize) {
        let orientation: BasicOrientation

        if size.width > size.height {
            orientation = .landscape
        } else {
            orientation = .portrait
        }
        
        self = orientation
    }
    
    /// Get the opposite orientation to the current one. For some operations
    /// it is useful to know this information so that we can simply flip
    /// around to get the reverse value.
    public var oppositeOrientation: BasicOrientation {
        switch self {
        case .landscape: return .portrait
        case .portrait: return .landscape
        }
    }
}

/// Implement this protocol to detect current orientation.
@objc public protocol OrientationDetectorType {
    
    /// Get the current screen size, from which we can deduce the orientation
    /// by computing width/height ratio.
    var currentScreenSize: CGSize { get }
}

public extension OrientationDetectorType {
    public var orientation: BasicOrientation {
        return BasicOrientation(size: currentScreenSize)
    }
}
