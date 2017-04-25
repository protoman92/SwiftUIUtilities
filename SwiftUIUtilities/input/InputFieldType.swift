//
//  InputFieldType.swift
//  SwiftInputView
//
//  Created by Hai Pham on 4/18/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

/// UIView subclasses that can accept and display an input should implement
/// this protocol for user with InputView. This is because we will not
/// necessarily be using a base UITextField for text input.
public protocol InputFieldType: class {
    
    /// Get the currently displayed text.
    var text: String? { get set }
    
    /// Get the currently active keyboard type.
    var keyboardType: UIKeyboardType { get set }
    
    /// Whether the input is secure. Applicable to password fields.
    var isSecureTextEntry: Bool { get set }
    
    /// A placeholder text for when there is no input.
    var placeholder: String? { get set }
    
    /// Text color for placeholder.
    var placeholderTextColor: UIColor? { get set }
    
    /// Get the placeholder view for this current inputField. For views that
    /// do not have a separate view for placeholder, return those views. This
    /// view can be used for dynamically adding constraints (e.g. when another
    /// view wants to align itself to this view).
    var placeholderView: UIView? { get }
    
    /// The input field's active text color.
    var textColor: UIColor? { get set }
    
    /// The input field's active tint color.
    var tintColor: UIColor! { get set }
    
    /// The input field's text alignment.
    var textAlignment: NSTextAlignment { get set }
    
    /// Autocorrect type for this inputField.
    var autocorrectionType: UITextAutocorrectionType { get set }
    
    /// Since we cannot ask Reactive with constraint on type to implement
    /// another protocol, we need to directly get the rx.text ControlProperty.
    /// For e.g. for UITextField it should be rx.text.
    var rxText: Observable<String?> { get }
    
    /// This method will be called when the current input field loses focus.
    ///
    /// - Returns: A Bool value.
    @discardableResult
    func resignFirstResponder() -> Bool
}
