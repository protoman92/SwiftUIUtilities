//
//  UIViewControllerPresenter.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/27/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Implement this protocol to provide presenter interface for view controllers.
@objc public protocol ViewControllerPresenterType: PresenterType {
    /// This is called when the controller calls viewDidLoad().
    ///
    /// - Parameter controller: The current UIViewController instance.
    func viewDidLoad(for controller: UIViewController)
    
    /// This is called when the controller calls  viewWillAppear(animated:).
    ///
    /// - Parameters:
    ///   - controller: The current UIViewController instance.
    ///   - animated: A Bool value.
    func viewWillAppear(for controller: UIViewController, animated: Bool)
    
    /// This is called when the controller calls viewDidAppear(animated:).
    ///
    /// - Parameters:
    ///   - controller: The current UIViewController instance.
    ///   - animated: A Bool value.
    func viewDidAppear(for controller: UIViewController, animated: Bool)
    
    
    /// This is called when the controller calls viewWillDisappear(animated:)
    ///
    /// - Parameters:
    ///   - controller: The current UIViewController instance.
    ///   - animated: A Bool value.
    func viewWillDisappear(for controller: UIViewController, animated: Bool)
    
    /// This is called when the controller calls viewDidDisappear(animated:).
    ///
    /// - Parameters:
    ///   - controller: The current UIViewController instance.
    ///   - animated: A Bool value.
    func viewDidDisappear(for controller: UIViewController, animated: Bool)
}

/// This Presenter class is used for UIViewController. It contains methods
/// such as viewDidLoad, viewDidAppear etc. so that the owner view controller
/// can delegate to.
@objc open class BaseViewControllerPresenter: BasePresenter {
    override open var presentedView: UIView? {
        return (viewDelegate as? UIViewController)?.view
    }
    
    open func viewDidLoad(for controller: UIViewController) {}
    
    open func viewWillAppear(for controller: UIViewController, animated: Bool) {}
    
    open func viewDidAppear(for controller: UIViewController, animated: Bool) {}
    
    open func viewWillDisappear(for controller: UIViewController, animated: Bool) {}
    
    open func viewDidDisappear(for controller: UIViewController, animated: Bool) {}
}

extension BaseViewControllerPresenter: ViewControllerPresenterType {}

extension UIViewController: PresenterDelegate {}
