//
//  ListViews.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/24/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

/// Implement this protocol to provide cell identifier.
public protocol CellIdentifiableType: class {}

public extension CellIdentifiableType {
    
    /// Get the cell's identifier.
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: CellIdentifiableType {}
extension UITableViewCell: CellIdentifiableType {}

/// Implement this protocol to register/own cells.
public protocol CellOwnerType {
    associatedtype CellType: UIView
    
    /// This method is common to both UICollectionView and UITableView.
    ///
    /// - Parameters:
    ///   - cellClass: Any class object.
    ///   - identifier: A String value.
    func register(_ cellClass: AnyClass?, with identifier: String)
    
    /// Deque a cell with an identifier.
    ///
    /// - Parameters:
    ///   - id: A String value.
    ///   - at: An IndexPath instance.
    /// - Returns: A CellType istance.
    func dequeReusableCell(with id: String, for indexPath: IndexPath) -> CellType
}

public extension CellOwnerType {
    
    /// Register a cell type.
    ///
    /// - Parameter type: A CellType type.
    public func register<C>(with type: C.Type) where C: UIView, C: CellIdentifiableType {
        register(type.self, with: type.identifier)
    }
    
    /// Deque a cell with a CellIdentifiableType subclass.
    ///
    /// - Parameters:
    ///   - type: A CellIdentifierType subclass type.
    ///   - indexPath: An IndexPath instance.
    /// - Returns: An optional CellIdentifierType instance.
    public func deque<C>(with type: C.Type, for indexPath: IndexPath) -> C?
        where C: CellIdentifiableType
    {
        return dequeReusableCell(with: type.identifier, for: indexPath) as? C
    }
}

extension UICollectionView: CellOwnerType {
    public typealias CellType = UICollectionViewCell
    
    public func register(_ cellClass: AnyClass?, with identifier: String) {
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    public func dequeReusableCell(with id: String, for indexPath: IndexPath)
        -> UICollectionViewCell
    {
        return dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
    }
}

extension UITableView: CellOwnerType {
    public typealias CellType = UITableViewCell
    
    public func register(_ cellClass: AnyClass?, with identifier: String) {
        register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    public func dequeReusableCell(with id: String, for indexPath: IndexPath)
        -> UITableViewCell
    {
        return dequeueReusableCell(withIdentifier: id, for: indexPath)
    }
}
