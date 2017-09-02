//
//  CoreGraphics.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 9/2/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import Foundation

extension CGPoint {
    public func difference(from point: CGPoint) -> CGPoint {
        return CGPoint(x: x - point.x, y: y - point.y)
    }
}
