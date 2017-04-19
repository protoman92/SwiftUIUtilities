//
//  DynamicFontType.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/19/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import UIKit

/// Enums that represent font names should implement this protocol.
public protocol FontRepresentationType {
    
    /// Create a new FontRepresentationType from a raw Int value.
    ///
    /// - Parameter value: An Int value.
    /// - Returns: A FontRepresentationType instance.
    static func from(value: Int) -> FontRepresentationType?
    
    /// Return the associated font name.
    var value: String { get }
}

/// UIView subclasses that can display a text and wish to dynamically change
/// UIFont based on InterfaceBuilder values should implement this protocol.
public protocol DynamicFontType: class {
    
    /// The currently active UIFont instance.
    var activeFont: UIFont? { get set }
    
    /// The name of the font, as represented by an Int enum.
    var fontName: Int? { get set }
    
    /// The font size, as represented by an Int enum.
    var fontSize: Int? { get set }
}

public extension DynamicFontType {
    
    /// Get the correct SizeRepresentationType type to parse fontSize.
    fileprivate static var sizePresentationType: SizeRepresentationType.Type? {
        return TextSize.self
    }
}

public extension DynamicFontType {
    
    /// Set font dynamically by checking fontName and fontValue for the
    /// appropriate values to initialize a new UIFont.
    public func setFontDynamically() {
        guard
            let fontName = self.fontName,
            let fontSize = self.fontSize,
            let infoDictionary = Bundle.main.infoDictionary,
            let appName = infoDictionary[kCFBundleNameKey as String] as? String,
            let clsName = readPropertyList(key: "FontNameClass") as? String,
            
            /// Create the FontRepresentationClass. We need to append the
            /// appName in front of the class name in Swift.
            let fontCls = NSClassFromString("\(appName).\(clsName)")
                as? FontRepresentationType.Type,
        
            let fontInstance = fontCls.from(value: fontName),
            let sizeCls = Self.sizePresentationType,
            let sizeInstance = sizeCls.from(value: fontSize),
            let size = sizeInstance.value ?? activeFont?.pointSize,
            let newFont = UIFont(name: fontInstance.value, size: size)
        else {
            debugException()
            activeFont = UIFont.systemFont(ofSize: 14)
            return
        }
        
        activeFont = newFont
    }
}
