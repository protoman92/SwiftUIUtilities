//
//  ControllerPresentable.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 5/3/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Implement this protocol to present dialog controllers. We shall introduce
/// a custom present(viewControllerToPresent:animated:completion:) method in
/// order to simulate dialog appearance.
@objc public protocol ControllerPresentableType: class {
    
    /// Present a UIViewController instance. The method is different from
    /// UIViewController.present(_:animated:completion:) because we want
    /// to mark this method as @objc-compliant. If we use the same method
    /// name and signatures, the compiler will complain.
    ///
    /// - Parameters:
    ///   - viewController: The UIViewController to be presented.
    ///   - animated: A Bool value.
    ///   - completion: Completion closure.
    @objc func presentController(_ controller: UIViewController,
                                 animated: Bool,
                                 completion: (() -> Void)?)
}

extension UIViewController: ControllerPresentableType {
    
    /// Present a UIViewController instance. The method is different from
    /// UIViewController.present(_:animated:completion:) because we want
    /// to mark this method as @objc-compliant. If we use the same method
    /// name and signatures, the compiler will complain.
    ///
    /// - Parameters:
    ///   - viewController: The UIViewController to be presented.
    ///   - animated: A Bool value.
    ///   - completion: Completion closure.
    @objc public func presentController(_ controller: UIViewController,
                                        animated: Bool,
                                        completion: (() -> Void)?) {
        present(controller, animated: animated, completion: completion)
    }
}
