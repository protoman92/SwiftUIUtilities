//
//  UICollectionViews.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/25/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// We can use this to avoid explicitly declaring element kind, since the
/// variable names are really long.
public enum ReusableViewKind {
    case header
    case footer
    
    public init?(from value: String) {
        switch value {
        case ReusableViewKind.header.value:
            self = .header
            
        case ReusableViewKind.footer.value:
            self = .footer
            
        default:
            return nil
        }
    }
    
    /// Get the associated reusable element kind.
    public var value: String {
        switch self {
        case .header:
            return UICollectionElementKindSectionHeader
            
        case .footer:
            return UICollectionElementKindSectionFooter
        }
    }
}

/// Implement this protocol to provide information for reusable views.
public protocol ReusableViewIdentifierType {
    
    /// Get the reusable view kind (e.g. header/footer).
    static var kind: ReusableViewKind { get }
}

public extension ReusableViewIdentifierType {
    
    /// Get the reusable view identifier.
    public static var identifier: String {
        return String(describing: self)
    }
}

public extension UICollectionView {
    
    /// Register a reusable view kind with a R instance.
    ///
    /// - Parameter type: The R class type.
    public func registerClass<R>(_ type: R.Type) where
        R: UICollectionReusableView & ReusableViewIdentifierType
    {
        register(type.self,
                 forSupplementaryViewOfKind: type.kind.value,
                 withReuseIdentifier: type.identifier)
    }
    
    /// Register a reusable view nib.
    ///
    /// - Parameters:
    ///   - type: The R class type.
    ///   - bundle: A Bundle instance.
    public func registerNib<R>(_ type: R.Type, bundle: Bundle? = nil) where
        R: UICollectionReusableView & ReusableViewIdentifierType
    {
        let identifier = type.identifier
        let nib = UINib(nibName: identifier, bundle: bundle)
        
        register(nib,
                 forSupplementaryViewOfKind: type.kind.value,
                 withReuseIdentifier: identifier)
    }
    
    /// Deque a UICollectionReusableView with a R type.
    ///
    /// - Parameters:
    ///   - type: A R type.
    ///   - indexPath: An IndexPath instance.
    /// - Returns: An optional UICollectionReusableView instance.
    public func deque<R>(_ type: R.Type, at indexPath: IndexPath) -> R? where
        R: UICollectionReusableView & ReusableViewIdentifierType
    {
        return dequeueReusableSupplementaryView(
            ofKind: type.kind.value,
            withReuseIdentifier: type.identifier,
            for: indexPath) as? R
    }
}
