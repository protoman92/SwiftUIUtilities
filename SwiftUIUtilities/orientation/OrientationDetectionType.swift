//
//  OrientationDetectionType.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/27/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Implement this protocol to detect current orientation.
public protocol OrientationDetectionType {}

public extension OrientationDetectionType {
    public var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
}
