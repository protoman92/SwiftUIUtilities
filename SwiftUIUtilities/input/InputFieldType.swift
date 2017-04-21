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
    
    /// The input field's active text color.
    var textColor: UIColor? { get set }
    
    /// The input field's active tint color.
    var tintColor: UIColor! { get set }
    
    /// Since we cannot ask Reactive with constraint on type to implement
    /// another protocol, we need to directly get the rx.text ControlProperty.
    /// For e.g. for UITextField it should be rx.text.
    var rxText: ControlProperty<String?> { get }
    
    /// This method will be called when the current input field loses focus.
    ///
    /// - Returns: A Bool value.
    @discardableResult
    func resignFirstResponder() -> Bool
}

extension UITextField: InputFieldType {
    public var rxText: ControlProperty<String?> {
        return rx.text
    }
}
