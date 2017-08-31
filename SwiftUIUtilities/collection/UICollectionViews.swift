//
//  UICollectionViewUtil.swift
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
    
    /// Register a reusable view kind with a ReusableViewIdentifierType
    /// instance.
    ///
    /// - Parameter type: A ReusableViewIdentifierType instance.
    public func register<R>(with type: R.Type)
        where R: UICollectionReusableView, R: ReusableViewIdentifierType
    {
        register(type.self,
                 forSupplementaryViewOfKind: type.kind.value,
                 withReuseIdentifier: type.identifier)
    }
    
    /// Deque a UICollectionReusableView with a ReusableViewIdentifierType
    /// type.
    ///
    /// - Parameters:
    ///   - type: A ReusableViewIdentifierType type.
    ///   - indexPath: An IndexPath instance.
    /// - Returns: An optional UICollectionReusableView instance.
    public func deque<R>(with type: R.Type, at indexPath: IndexPath) -> R?
        where R: UICollectionReusableView, R: ReusableViewIdentifierType
    {
        return dequeueReusableSupplementaryView(
            ofKind: type.kind.value,
            withReuseIdentifier: type.identifier,
            for: indexPath) as? R
    }
}
