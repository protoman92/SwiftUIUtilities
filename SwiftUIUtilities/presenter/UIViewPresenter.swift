//
//  UIViewPresenter.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/18/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// This Presenter should be used for UIView subclasses. Since there are
/// many different subclasses, each Presenter instance needs to reimplement
/// the methods outlined below, and its UIView needs to explicitly call them
/// where appropriate.
@objc open class BaseViewPresenter: BasePresenter {
    override open var presentedView: UIView? {
        return viewDelegate as? UIView
    }
    
    public override init<E: UIView>(view: E) {
        super.init(view: view)
    }
    
    /// This method should be called when the UIView's constructor is called.
    ///
    /// - Parameter view: The UIView handled by the current Presenter.
    open func onViewInit(_ view: UIView) {}
    
    /// This method should be called when the UIView's awakeFromNib() method
    /// is called. Note that this method may not be called if the UIView is
    /// constructed not from a Nib.
    ///
    /// - Parameter view: The UIView handled by the current Presenter.
    open func awakeFromNib(_ view: UIView) {}
    
    /// This method should be called when the UIView's layoutSubviews() method
    /// is called.
    ///
    /// - Parameter view: The UIView handled by the current Presenter.
    open func layoutSubviews(_ view: UIView) {}
    
    /// This method should be called the UIView's remoteFromSuperview() method
    /// is called.
    ///
    /// - Parameter view: The UIView handled by the current Presenter.
    open func removeFromSuperview(_ view: UIView) {}
}

extension UIView: PresenterDelegate {}
