//
//  ControlTestUtil.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/28/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import UIKit

extension UIControl {
    
    /// Override this method to swizzle sendAction(_:to:for:).
    override open class func initialize() {
        guard self === UIControl.self else {
            return
        }
        
        once(using: NSUUID().uuidString) {
            let oSelector = #selector(self.sendAction(_:to:for:))
            let sSelector = #selector(self.ssa(_:to:for:))
            let oMethod = class_getInstanceMethod(self, oSelector)
            let sMethod = class_getInstanceMethod(self, sSelector)
            
            let didAddMethod = class_addMethod(self, oSelector,
                                               method_getImplementation(sMethod),
                                               method_getTypeEncoding(sMethod))
            
            if didAddMethod {
                class_replaceMethod(self,
                                    sSelector,
                                    method_getImplementation(oMethod),
                                    method_getTypeEncoding(oMethod))
            } else {
                method_exchangeImplementations(oMethod, sMethod)
            }
        }
    }
    
    /// Swizzle this method for sendAction(_:to:for)
    ///
    /// - Parameters:
    ///   - action: A Selector instance.
    ///   - target: An AnyObject instance that will receive the action.
    ///   - event: An optional UIEvent instance.
    func ssa(_ action: Selector, to target: AnyObject?, for event: UIEvent?) {
        _ = target?.perform(action, with: self)
    }
}
