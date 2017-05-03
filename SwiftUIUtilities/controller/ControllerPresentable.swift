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
public protocol ControllerPresentableType: class {
    
    /// Present a UIViewController instance.
    ///
    /// - Parameters:
    ///   - viewController: The UIViewController to be presented.
    ///   - animated: A Bool value.
    ///   - completion: Completion closure.
    func present(_ viewController: UIViewController,
                 animated: Bool,
                 completion: (() -> Void)?)
}

extension UIViewController: ControllerPresentableType {}
