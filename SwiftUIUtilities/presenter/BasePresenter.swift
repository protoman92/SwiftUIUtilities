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
    fileprivate weak var view: PresenterDelegate?
    
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

extension BasePresenter: ActionSelectorType {
    public func actionReceived(sender: AnyObject, event: UIEvent) {
        actionExecuted(sender: sender, event: event)
    }
    
    public func actionExecuted(sender: AnyObject, event: UIEvent) {
        fatalError()
    }
}

/// UIViewController/UIView instances should implement this protocol to have
/// their views handled by the respective presenters.
public protocol PresenterDelegate: class {}
