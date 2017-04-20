//
//  UITextDisplayUtil.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/19/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

open class BaseLabel: UILabel {
    
    /// These value will be set via InterfaceBuilder.
    @IBInspectable public var fontName: Int?
    @IBInspectable public var fontSize: Int?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        setFontDynamically()
    }
}

extension BaseLabel: DynamicFontType {
    public var activeFont: UIFont? {
        get { return font }
        set { font = newValue }
    }
}

open class BaseTextField: UITextField {
    
    /// These value will be set via InterfaceBuilder.
    @IBInspectable public var fontName: Int?
    @IBInspectable public var fontSize: Int?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        setFontDynamically()
    }
}

extension BaseTextField: DynamicFontType {
    public var activeFont: UIFont? {
        get { return font }
        set { font = newValue }
    }
}

open class BaseTextView: UITextView {
    
    /// These value will be set via InterfaceBuilder.
    @IBInspectable public var fontName: Int?
    @IBInspectable public var fontSize: Int?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        setFontDynamically()
    }
}

extension BaseTextView: DynamicFontType {
    public var activeFont: UIFont? {
        get { return font }
        set { font = newValue }
    }
}

open class BaseButton: UIButton {
    
    /// These value will be set via InterfaceBuilder.
    @IBInspectable public var fontName: Int?
    @IBInspectable public var fontSize: Int?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        setFontDynamically()
    }
}

extension BaseButton: DynamicFontType {
    public var activeFont: UIFont? {
        get { return titleLabel?.font }
        set { titleLabel?.font = newValue }
    }
}
