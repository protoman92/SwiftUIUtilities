//
//  UITextDisplayUtil.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/19/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

public final class BaseLabel: UILabel {
    
    /// These value will be set via InterfaceBuilder.
    @IBInspectable public var fontName: Int?
    @IBInspectable public var fontSize: Int?
    
    override public func awakeFromNib() {
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

public final class BaseTextField: UITextField {
    
    /// These value will be set via InterfaceBuilder.
    @IBInspectable public var fontName: Int?
    @IBInspectable public var fontSize: Int?
    
    override public func awakeFromNib() {
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

public final class BaseButton: UIButton {
    
    /// These value will be set via InterfaceBuilder.
    @IBInspectable public var fontName: Int?
    @IBInspectable public var fontSize: Int?
    
    override public func awakeFromNib() {
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
