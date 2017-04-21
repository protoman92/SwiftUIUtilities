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
    @IBInspectable public var fontName: String?
    @IBInspectable public var fontSize: String?
    
    /// Use this variable to set font only once. We should not use
    /// awakeFromNib() since it will not be called if we construct an instance
    /// dynamically.
    fileprivate var initialized = false
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        guard !initialized else {
            return
        }
        
        defer { initialized = true }
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
    @IBInspectable public var fontName: String?
    @IBInspectable public var fontSize: String?
    
    /// Use this variable to set font only once. We should not use
    /// awakeFromNib() since it will not be called if we construct an instance
    /// dynamically.
    fileprivate var initialized = false
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        guard !initialized else {
            return
        }
        
        defer { initialized = true }
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
    @IBInspectable public var fontName: String?
    @IBInspectable public var fontSize: String?
    
    /// Use this variable to set font only once. We should not use
    /// awakeFromNib() since it will not be called if we construct an instance
    /// dynamically.
    fileprivate var initialized = false
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        guard !initialized else {
            return
        }
        
        defer { initialized = true }
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
    @IBInspectable public var fontName: String?
    @IBInspectable public var fontSize: String?
    
    /// Use this variable to set font only once. We should not use
    /// awakeFromNib() since it will not be called if we construct an instance
    /// dynamically.
    fileprivate var initialized = false
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        guard !initialized else {
            return
        }
        
        defer { initialized = true }
        setFontDynamically()
    }
}

extension BaseButton: DynamicFontType {
    public var activeFont: UIFont? {
        get { return titleLabel?.font }
        set { titleLabel?.font = newValue }
    }
}
