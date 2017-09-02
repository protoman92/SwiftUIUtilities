//
//  TableViews.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 9/2/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

public protocol HeaderFooterIdentifierType {}

public extension HeaderFooterIdentifierType {
    
    /// Get the header footer view identifier.
    public static var identifier: String {
        return String(describing: self)
    }
}

public extension UITableView {
    
    /// Register a reusable view kind with a HF instance.
    ///
    /// - Parameter type: The HF class type.
    public func registerClass<HF>(with type: HF.Type) where
        HF: UIView & HeaderFooterIdentifierType
    {
        register(type, forHeaderFooterViewReuseIdentifier: type.identifier)
    }
    
    /// Register a header footer view nib.
    ///
    /// - Parameters:
    ///   - type: The HF class type.
    ///   - bundle: A Bundle instance.
    public func registerNib<HF>(with type: HF.Type, bundle: Bundle? = nil) where
        HF: UIView & HeaderFooterIdentifierType
    {
        let identifier = type.identifier
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    /// Deque a UIView with a HF type.
    ///
    /// - Parameters:
    ///   - type: A HF type.
    ///   - indexPath: An IndexPath instance.
    /// - Returns: An optional HF instance.
    public func deque<HF>(with type: HF.Type, at indexPath: IndexPath) -> HF?
        where HF: UIView & HeaderFooterIdentifierType
    {
        let identifier = type.identifier
        return dequeueReusableHeaderFooterView(withIdentifier: identifier) as? HF
    }
}
