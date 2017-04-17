//
//  BasePresenter.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/18/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// We use Presenters to abstract away View interactions. Since Presenters
/// can be inherited from/subclassed, we have more leeway with regards to
/// DRY.
@objc public class BasePresenter: NSObject {
    weak var view: PresenterDelegate?
    
    /// Return view instance.
    public var viewDelegate: PresenterDelegate? {
        return view
    }
    
    /// Return the view presented by this presenter.
    public var presentedView: UIView? {
        fatalError("Must override this variable")
    }
    
    public init<E: PresenterDelegate>(view: E) {
        self.view = view
    }
}

public extension BasePresenter {
    /// This method shall be the master method that receives all important 
    /// UIView events, such as UIButton's TouchDown. We can insert 
    /// analytics-tracking methods here to catch all user interactons.
    ///
    /// - Parameters:
    ///   - sender: The object that was interacted with.
    ///   - event: The interaction event.
    @objc public func actionReceived(_ sender: AnyObject,
                                     forEvent event: UIEvent) {
        actionExecuted(sender, forEvent: event)
    }
    
    /// Override this method to provide specific actions to be taken.
    ///
    /// - Parameters:
    ///   - sender: The object that was interacted with.
    ///   - event: The interaction event.
    @objc public func actionExecuted(_ sender: AnyObject,
                                     forEvent event: UIEvent) {
        fatalError()
    }
}

/// UIViewController/UIView instances should implement this protocol to have
/// their views handled by the respective presenters.
public protocol PresenterDelegate: class {}
