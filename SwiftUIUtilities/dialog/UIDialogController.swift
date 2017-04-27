//
//  UIDialogController.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/27/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import SwiftUtilities
import UIKit

/// Dialogs are view controllers that can be presented on top of the current
/// view controller, and usually floats over it.
open class UIDialogController: UIBaseViewController {
    
    /// Subclasses should provide DialogPresenter-derived types.
    override open var presenterType: ViewControllerPresenterType.Type {
        return DialogPresenter.self
    }
    
    open class DialogPresenter: BaseViewControllerPresenter {
        
        /// Common DisposeBag instance for rx-related operations.
        public let disposeBag = DisposeBag()
        
        override open func viewDidLoad(for controller: UIViewController) {
            super.viewDidLoad(for: controller)
            addDismissButton(for: controller)
        }
        
        /// Add a background button that dismisses the current dialog once 
        /// clicked.
        ///
        /// - Parameter controller: The current UIViewController instance.
        open func addDismissButton(for controller: UIViewController) {
            guard let view = controller.view else {
                debugException()
                return
            }
            
            let button = UIButton()
            button.accessibilityIdentifier = backgroundButtonId
            button.backgroundColor = .darkGray
            
            button.rx.controlEvent(.touchDown)
                .asObservable()
                .doOnNext({[weak self, weak controller] in
                    self?.dismiss(dialog: controller)
                })
                .subscribe()
                .addDisposableTo(disposeBag)
            
            view.addSubview(button)
            view.addFitConstraints(for: button)
        }
        
        /// Add a DialogViewType instance as a subview to the main view.
        ///
        /// - Parameters:
        ///   - view: A DialogViewType instance.
        ///   - controller: The current UIViewController instance.
        open func add<V>(dialogView: V, for controller: UIViewController)
            where V: UIView, V: DialogViewType
        {
            controller.view?.populateSubviews(with: dialogView)
        }
        
        func dismiss(dialog: UIViewController?) {
            dialog?.dismiss(animated: true, completion: nil)
        }
    }
}

extension UIDialogController.DialogPresenter: DialogIdentifierType {}
