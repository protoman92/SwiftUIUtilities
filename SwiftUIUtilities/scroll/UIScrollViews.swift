//
//  UIScrollViews.swift
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
    private func didOverscroll(_ threshold: CGFloat,
                               _ offset: CGFloat,
                               _ contentDimen: CGFloat,
                               _ dimen: CGFloat) -> Bool {
        return offset < 0 || (offset + dimen) >= (contentDimen + threshold)
    }
    
    /// Subscribe to this Observable to be notified when the content size is
    /// changes.
    public var contentSize: Observable<CGSize> {
        return observe(CGSize.self, "contentSize")
            .map({$0 ?? CGSize.zero})
            .distinctUntilChanged()
    }
    
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
        return willBeginDecelerating
            .withLatestFrom(contentOffset)
            .map(direction.directionContentOffset)
            .filter({$0 * CGFloat(direction.rawValue) > 0})
            .withLatestFrom(
                contentSize.map(direction.directionContentDimension),
                resultSelector: {
                    let bounds = self.base.frame
                    let dimen = direction.directionContentDimension(bounds.size)
                    return self.didOverscroll(threshold, $0.0, $0.1, dimen)
                }
            )
            .filter({$0})
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
}

fileprivate extension Unidirection {

    /// Get the content offset value associated with a direction from a CGPoint.
    ///
    /// - Parameter point: A CGPoint instance.
    /// - Returns: A CGFloat value.
    func directionContentOffset(_ point: CGPoint) -> CGFloat {
        return isHorizontal() ? point.x : point.y
    }

    /// Get the content size value associated with a direction from a CGSize.
    ///
    /// - Parameter size: A CGSize instance.
    /// - Returns: A CGFloat value.
    func directionContentDimension(_ size: CGSize) -> CGFloat {
        return isHorizontal() ? size.width : size.height
    }
}
