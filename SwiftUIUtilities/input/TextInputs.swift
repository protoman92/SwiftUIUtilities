//
//  TextFields.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/18/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import UIKit

/// Input fields that have an inputAccessoryView should implement this
/// protocol to control this field's getter and setter.
public protocol UITextInputWithAccessory: class {
    
    /// Set this to add accessory to input field.
    var inputAccessoryView: UIView? { get set }
}

public extension UITextInputWithAccessory {
    
    /// Add a completion accessory to the current input field. For input
    /// fields with certain keyboard types, the soft keyboard does not have
    /// any way to be dismissed (such as Number keyboards), so this accessory
    /// allows users to confirm/cancel input text.
    ///
    /// - Parameter completionAccessory: A CompletionAccessory instance.
    public func addAccessory(_ accessory: CompletionAccessory) {
        let numberToolbar = UIToolbar()
        
        numberToolbar.barStyle = UIBarStyle.blackTranslucent
        
        /// When the user presses cancel, the text in the input field will
        /// be deleted.
        let cancel = UIBarButtonItem(title: accessory.cancelString,
                                     style: .plain,
                                     target: accessory.target,
                                     action: accessory.selector)
        
        cancel.accessibilityIdentifier = accessory.cancelId
        cancel.tintColor = .white
        
        /// When the user press confirm, resignFirstResponder() should be 
        /// called.
        let confirm = UIBarButtonItem(title: accessory.confirmString,
                                      style: .plain,
                                      target: accessory.target,
                                      action: accessory.selector)
        
        confirm.accessibilityIdentifier = accessory.confirmId
        confirm.tintColor = .white
        
        /// Flexible space between cancel and confirm buttons.
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil,
                                        action: nil)
        
        numberToolbar.items = [cancel, flexSpace, confirm]
        numberToolbar.sizeToFit()
        inputAccessoryView = numberToolbar
    }
}

extension UITextField: UITextInputWithAccessory {}
extension UITextView: UITextInputWithAccessory {}

public struct CompletionAccessory {
    fileprivate weak var target: AnyObject?
    fileprivate var selector: Selector?
    fileprivate var confirmString: String
    fileprivate var cancelString: String
    fileprivate var confirmId: String
    fileprivate var cancelId: String
    
    fileprivate init() {
        confirmString = ""
        cancelString = ""
        confirmId = ""
        cancelId = ""
    }
    
    public final class Builder {
        fileprivate var accessory: CompletionAccessory
        
        fileprivate init() {
            accessory = CompletionAccessory()
        }
        
        /// Set the accessory's target instance.
        ///
        /// - Parameter target: A target to be used for the selector.
        /// - Returns: The current Builder instance.
        public func with(target: AnyObject?) -> Builder {
            accessory.target = target
            return self
        }
        
        /// Set the accessory's selector instance.
        ///
        /// - Parameter selector: A Selector instance.
        /// - Returns: The current Builder instance.
        public func with(selector: Selector) -> Builder {
            accessory.selector = selector
            return self
        }
        
        /// Set the accessory's selector instance using actionReceived()
        /// from an ActionSelectorType instance.
        ///
        /// - Parameter type: An ActionSelectorType instance.
        /// - Returns: The current Builder instance.
        public func with(selectorType type: ActionSelectorType) -> Builder {
            return with(selector: #selector(type.actionReceived(sender:event:)))
        }
        
        /// Set the accessory's confirmString value.
        ///
        /// - Parameter confirmString: A String value.
        /// - Returns: The current Builder instance.
        public func with(confirmString: String) -> Builder {
            accessory.confirmString = confirmString
            return self
        }
        
        /// Set the accessory's cancelString value.
        ///
        /// - Parameter cancelString: A String value.
        /// - Returns: The current Builder instance.
        public func with(cancelString: String) -> Builder {
            accessory.cancelString = cancelString
            return self
        }
        
        /// Set the accessory's confirmId value.
        ///
        /// - Parameter confirmId: A String value to be used in selector.
        /// - Returns: The current Builder instance.
        public func with(confirmId: String) -> Builder {
            accessory.confirmId = confirmId
            return self
        }
        
        /// Set the accessory's cancelId value.
        ///
        /// - Parameter cancelId: A String value to be used in selector.
        /// - Returns: The current Builder instance.
        public func with(cancelId: String) -> Builder {
            accessory.cancelId = cancelId
            return self
        }
        
        public func build() -> CompletionAccessory {
            return accessory
        }
    }
}

public extension CompletionAccessory {
    
    /// Return a Builder instance.
    public static func builder() -> Builder {
        return Builder()
    }
}
