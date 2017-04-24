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

/// Default font representation. We need to use a class instead of an enum
/// due to NSClassFromString()
public enum DefaultFont: Int {
    case normal = 1
    case bold
    case italic
}

extension DefaultFont: FontRepresentationType {
    public static func from(value: Int) -> FontRepresentationType? {
        switch value {
        case 1:
            return normal
            
        case 2:
            return bold
            
        case 3:
            return italic
            
        default:
            return nil
        }
    }
    
    public var value: String {
        switch self {
        case .normal:
            return "HelveticaNeue"
            
        case .bold:
            return "HelveticaNeue-Bold"
            
        case .italic:
            return "HelveticaNeue-Italic"
        }
    }
}

/// UIView subclasses that can display a text and wish to dynamically change
/// UIFont based on InterfaceBuilder values should implement this protocol.
public protocol DynamicFontType: class {
    
    /// The currently active UIFont instance.
    var activeFont: UIFont? { get set }
    
    /// The name of the font, as represented by an Int enum.
    var fontName: String? { get set }
    
    /// The font size, as represented by an Int enum.
    var fontSize: String? { get set }
}

public extension DynamicFontType {
    
    /// Get the correct SizeRepresentationType type to parse fontSize.
    var sizePresentationType: SizeRepresentationType.Type? {
        return TextSize.self
    }
    
    /// Get the name for the class that holds font names. This name should
    /// be defined in Info.plist.
    var fontRepresentationClassName: String? {
        return readPropertyList(key: "FontNameClass") as? String
    }
    
    /// Dynamically locale a FontRepresentationType as defined in Info.plist,
    /// or use DefaultFont.
    var fontRepresentationType: FontRepresentationType.Type? {
        guard
            let clsName = fontRepresentationClassName,
            let infoDictionary = Bundle(identifier: clsName)?.infoDictionary,
            let appName = infoDictionary[kCFBundleNameKey as String] as? String,
            
            /// Create the FontRepresentationClass. We need to append the
            /// appName in front of the class name in Swift.
            let fontClass = NSClassFromString("\(appName).\(clsName)")
                as? FontRepresentationType.Type
        else {
            return DefaultFont.self
        }
        
        return fontClass
    }
}

public extension DynamicFontType {
    
    /// Set font dynamically by checking fontName and fontValue for the
    /// appropriate values to initialize a new UIFont.
    public func setFontDynamically() {
        guard
            let fontName = Int(self.fontName ?? ""),
            let fontSize = Int(self.fontSize ?? ""),
            let fontCls = fontRepresentationType,
            let sizeCls = sizePresentationType,
            let fontInstance = fontCls.from(value: fontName),
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
