//
//  UIViewControllerPresenter.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/27/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import SwiftUtilities
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
    
    /// This is called when the controller calls viewWillTransition(to:with:).
    ///
    /// - Parameters:
    ///   - size: The current screen size.
    ///   - coordinator: A UIViewControllerTransitionCoordinator instance.
    ///   - controller: The current UIViewController instance.
    func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator,
        for controller: UIViewController
    )
}

/// This Presenter class is used for UIViewController. It contains methods
/// such as viewDidLoad, viewDidAppear etc. so that the owner view controller
/// can delegate to.
@objc open class BaseViewControllerPresenter: BasePresenter {
    override open var presentedView: UIView? {
        return viewController?.view
    }
    
    /// Get the current viewController. Throw an error if it is not available.
    public var viewController: UIViewController? {
        guard let controller = viewDelegate as? UIViewController else {
            debugException()
            return nil
        }

        return controller
    }
    
    /// Use this DisposeBag instance for rx-related operations.
    public let disposeBag = DisposeBag()
    
    /// When orientation size changes, this value will be updated.
    fileprivate var screenSize = Variable<CGSize>(CGSize.zero)
    
    open func viewDidLoad(for controller: UIViewController) {
        screenSize.value = UIScreen.main.bounds.size
        
        screenSize.asObservable().skip(1)
            .doOnNext({[weak self] in self?.onScreenSizeChanged(to: $0)})
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
    open func viewWillAppear(for controller: UIViewController, animated: Bool) {}
    
    open func viewDidAppear(for controller: UIViewController, animated: Bool) {}
    
    open func viewWillDisappear(for controller: UIViewController, animated: Bool) {}
    
    open func viewDidDisappear(for controller: UIViewController, animated: Bool) {}
    
    open func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator,
        for controller: UIViewController)
    {
        screenSize.value = size
    }
    
    /// This method is called when the screen size changes i.e. when the
    /// app changes orientation.
    ///
    /// - Parameter size: The new screen size. A CGSize instance.
    open func onScreenSizeChanged(to size: CGSize) {}
}

public extension BaseViewControllerPresenter {
    
    /// Return screenSize as part of OrientationDetectorType conformance.
    public var currentScreenSize: CGSize {
        return screenSize.value
    }
}

extension BaseViewControllerPresenter: ViewControllerPresenterType {}
extension BaseViewControllerPresenter: OrientationDetectorType {}
extension UIViewController: PresenterDelegate {}
