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
    
    /// Reactively scroll to top.
    ///
    /// - Parameter animated: A Bool value.
    /// - Returns: An Observable instance.
    public func rxScrollToTop(shouldAnimate animated: Bool)
        -> Observable<Bool>
    {
        return Completable
            .create(subscribe: {
                self.scrollToTop(shouldAnimate: animated)
                $0(.completed)
                return Disposables.create()
            })
            .asObservable()
            .map({_ in true})
            .ifEmpty(default: true)
    }
}

public extension UIScrollView {
    
    /// Scroll to bottom, with or without animation.
    ///
    /// - Parameter animated: A Bool value.
    public func scrollToBottom(shouldAnimate animated: Bool) {
        let bottomOrigin = CGPoint(x: 1, y: frame.minY + contentSize.height - 1)
        let bottomSize = CGSize(width: 1, height: 1)
        let bottomRect = CGRect(origin: bottomOrigin, size: bottomSize)
        scrollRectToVisible(bottomRect, animated: animated)
    }
    
    /// Reactively scroll to bottom.
    ///
    /// - Parameter animated: A Bool value.
    /// - Returns: An Observable instance.
    public func rxScrollToBottom(shouldAnimate animated: Bool)
        -> Observable<Bool>
    {
        return Completable
            .create(subscribe: {
                self.scrollToBottom(shouldAnimate: animated)
                $0(.completed)
                return Disposables.create()
            })
            .asObservable()
            .map({_ in true})
            .ifEmpty(default: true)
    }
}
