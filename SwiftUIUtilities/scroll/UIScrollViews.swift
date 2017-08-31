//
//  UIScrollViewUtil.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/18/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import UIKit

public extension UIScrollView {
    
    /// Scroll to top, with or without animation.
    ///
    /// - Parameter animated: A Bool value.
    public func scrollToTop(shouldAnimate animated: Bool) {
        let topRect = CGRect(x: 1, y: frame.minY, width: 1, height: 1)
        scrollRectToVisible(topRect, animated: animated)
    }
    
    /// Scroll to bottom, with or without animation.
    ///
    /// - Parameter animated: A Bool value.
    public func scrollToBottom(shouldAnimate animated: Bool) {
        let bottomOrigin = CGPoint(x: 1, y: frame.minY + contentSize.height - 1)
        let bottomSize = CGSize(width: 1, height: 1)
        let bottomRect = CGRect(origin: bottomOrigin, size: bottomSize)
        scrollRectToVisible(bottomRect, animated: animated)
    }
}

public extension Reactive where Base: UIScrollView {
    
    /// Subscribe to this Observable to be notified when the scroll view is
    /// overscrolled.
    ///
    /// - Parameters:
    ///   - threshold: Overscroll threshold beyond which an event is emitted.
    ///   - direction: A Unidirection instance.
    /// - Returns: An Observable instance.
    public func didOverscroll(threshold: CGFloat, direction: Unidirection)
        -> Observable<Unidirection>
    {
        return didEndDragging
            .withLatestFrom(contentOffset)
            .map(direction.directionValue)
            .filter({Swift.abs($0) >= threshold})
            .map({_ in direction})
    }
    
    /// Subscribe to this Observable to be notified when the scroll view is
    /// overscrolled in certain directions.
    ///
    /// - Parameters:
    ///   - threshold: Overscroll threshold beyond which an event is emitted.
    ///   - directions: A Sequence of Unidirection.
    /// - Returns: An Observable instance.
    public func didOverscroll<S>(threshold: CGFloat, directions: S)
        -> Observable<Unidirection> where
        S: Sequence, S.Iterator.Element == Unidirection
    {
        let obs = directions.map({didOverscroll(threshold: threshold, direction: $0)})
        return Observable.merge(obs)
    }
    
    /// Subscribe to this Observable to be notified when the scroll view is
    /// overscrolled in certain directions.
    ///
    /// - Parameters:
    ///   - threshold: Overscroll threshold beyond which an event is emitted.
    ///   - directions: A varargs of Unidirection.
    /// - Returns: An Observable instance.
    public func didOverscroll(threshold: CGFloat, directions: Unidirection...)
        -> Observable<Unidirection>
    {
        return didOverscroll(threshold: threshold, directions: directions)
    }
    
    /// Subscribe to this Observable to be notified when the content size is
    /// changes.
    ///
    /// - Returns: An Observable instance.
    public func contentSize() -> Observable<CGSize> {
        return observe(CGSize.self, "contentSize")
            .map({$0 ?? CGSize.zero})
            .distinctUntilChanged()
    }
}

fileprivate extension Unidirection {
    
    /// Get the value associated with a direction from a point.
    ///
    /// - Parameter point: A CGPoint instance.
    /// - Returns: A CGFloat value.
    func directionValue(_ point: CGPoint) -> CGFloat {
        return isHorizontal() ? point.x : point.y
    }
}
