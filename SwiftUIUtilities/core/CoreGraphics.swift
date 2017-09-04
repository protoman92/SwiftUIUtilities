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
    
    public func multiply(with value: CGFloat) -> CGPoint {
        return CGPoint(x: x * value, y: y * value)
    }
}

extension CGSize {
    public func difference(from size: CGSize) -> CGSize {
        return CGSize(width: width - size.width, height: height - size.height)
    }
    
    public func multiply(with value: CGFloat) -> CGSize {
        return CGSize(width: width * value, height: height * value)
    }
}
