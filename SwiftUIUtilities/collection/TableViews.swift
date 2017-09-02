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
    /// - Parameter type: A HF instance.
    public func register<HF>(with type: HF.Type) where
        HF: UIView, HF: HeaderFooterIdentifierType
    {
        register(type, forHeaderFooterViewReuseIdentifier: type.identifier)
    }
    
    /// Deque a UIView with a HF type.
    ///
    /// - Parameters:
    ///   - type: A HF type.
    ///   - indexPath: An IndexPath instance.
    /// - Returns: An optional HF instance.
    public func deque<HF>(with type: HF.Type, at indexPath: IndexPath) -> HF?
        where HF: UIView, HF: HeaderFooterIdentifierType
    {
        let identifier = type.identifier
        return dequeueReusableHeaderFooterView(withIdentifier: identifier) as? HF
    }
}
