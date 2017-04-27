//
//  UIBaseViewController.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/27/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Basic view controller class that uses a ViewControllerPresenterType
/// instance for controller-specific methods.
open class UIBaseViewController: UIViewController {
    
    /// Override this variable to provide custom presenter types.
    open var presenterType: ViewControllerPresenterType.Type {
        return BaseViewControllerPresenter.self
    }
    
    /// Get a new ViewControllerPresenterType instance.
    fileprivate var newPresenter: ViewControllerPresenterType {
        return presenterType.init(view: self)
    }
    
    /// Use this presenter to call view controller-specific methods.
    public lazy var presenter: ViewControllerPresenterType = self.newPresenter
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(for: self)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear(for: self, animated: animated)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear(for: self, animated: animated)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear(for: self, animated: animated)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidDisappear(for: self, animated: animated)
    }
}
