//
//  ScrollViews.swift
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
    
    /// Emits the differences between two consecutive emissions of contentOffset.
    public var contentOffsetChange: Observable<CGPoint> {
        return contentOffset
            .scan((last: CGPoint.zero, diff: CGPoint.zero), accumulator: {
                let lastOffset = $0.0.last
                let currentOffset = $0.1
                let diff = currentOffset.difference(from: lastOffset)
                return (last: currentOffset, diff: diff)
            })
            .map({$0.diff})
    }
    
    /// Subscribe to this Observable to be notified when the scroll view is
    /// overscrolled.
    ///
    /// - Parameters:
    ///   - threshold: Overscroll threshold beyond which an event is emitted.
    ///   - direction: A Unidirection instance.
    /// - Returns: An Observable instance.
    public func didOverscroll(_ threshold: CGFloat, _ direction: Unidirection)
        -> Observable<Unidirection>
    {
        return willBeginDecelerating
            .withLatestFrom(contentOffset)
            .map(direction.directionContentOffset)
            .filter({$0 * CGFloat(direction.rawValue) > 0})
            .withLatestFrom(
                contentSize.map(direction.directionContentDimension),
                resultSelector: {
                    let bounds = self.base.bounds
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
    public func didOverscroll<S>(_ threshold: CGFloat, _ directions: S)
        -> Observable<Unidirection> where
        S: Sequence, S.Iterator.Element == Unidirection
    {
        return Observable.merge(directions.map({didOverscroll(threshold, $0)}))
    }
    
    /// Subscribe to this Observable to be notified when the scroll view is
    /// overscrolled in certain directions.
    ///
    /// - Parameters:
    ///   - threshold: Overscroll threshold beyond which an event is emitted.
    ///   - directions: A varargs of Unidirection.
    /// - Returns: An Observable instance.
    public func didOverscroll(_ threshold: CGFloat, _ directions: Unidirection...)
        -> Observable<Unidirection>
    {
        return didOverscroll(threshold, directions)
    }
    
    /// Detect the scroll direction in which the view is moving.
    ///
    /// - Parameter threshold: A CGFloat value over which a scroll is considered
    ///                        to be in a particular direction. This value can
    ///                        be used to filter out overscroll bounces, but be
    ///                        careful not to set it so high that normal scrolls
    ///                        are not emitted either.
    /// - Returns: An Observable instance.
    public func scrollDirections(_ threshold: CGFloat) -> Observable<[Unidirection]> {
        return didScroll
            .withLatestFrom(contentOffsetChange)
            .map({Unidirection.directions($0, threshold)})
            .filter({$0.isNotEmpty})
    }
}

fileprivate extension Unidirection {
    
    /// Get the supposed direction a view is scrolling towards, based on its
    /// content offset difference and a threshold.
    ///
    /// - Parameters:
    ///   - point: A CGPoint instance.
    ///   - threshold: A CGFloat value.
    /// - Returns: An Array of Unidirection.
    static func directions(_ point: CGPoint, _ threshold: CGFloat)
        -> [Unidirection]
    {
        var directions = [Unidirection]()
        let x = point.x
        let y = point.y
        
        if x < 0 && Swift.abs(x) > threshold {
            directions.append(.left)
        } else if x > threshold {
            directions.append(.right)
        }
        
        if y < 0 && Swift.abs(y) > threshold {
            directions.append(.up)
        } else if y > threshold {
            directions.append(.down)
        }
        
        return directions
    }

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
