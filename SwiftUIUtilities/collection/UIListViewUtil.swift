//
//  UIListViewUtil.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/24/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

/// Implement this protocol to provide cell identifier.
public protocol CellIdentifierType: class {}

public extension CellIdentifierType {
    
    /// Get the cell's identifier.
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: CellIdentifierType {}
extension UITableViewCell: CellIdentifierType {}

/// Implement this protocol to register cells.
public protocol CellRegisterType {
    
    /// This method is common to both UICollectionView and UITableView.
    ///
    /// - Parameters:
    ///   - cellClass: Any class object.
    ///   - identifier: A String value.
    func register(_ cellClass: AnyClass?, with identifier: String)
}

/// Implement this protocol to deque cells.
public protocol CellDequeType {
    associatedtype CellType: UIView
    
    /// Deque a cell with an identifier.
    ///
    /// - Parameters:
    ///   - id: A String value.
    ///   - at: An IndexPath instance.
    /// - Returns: A CellType istance.
    func dequeReusableCell(with id: String, for indexPath: IndexPath) -> CellType
}

public extension CellRegisterType {
    
    /// Register a cell type.
    ///
    /// - Parameter type: A CellType type.
    public func register<C>(with type: C.Type) where C: UIView, C: CellIdentifierType {
        register(type.self, with: type.identifier)
    }
}

public extension CellDequeType {
    
    /// Deque a cell with a CellIdentifierType subclass.
    ///
    /// - Parameters:
    ///   - type: A CellIdentifierType subclass type.
    ///   - indexPath: An IndexPath instance.
    /// - Returns: An optional CellIdentifierType instance.
    public func deque<C>(with type: C.Type, for indexPath: IndexPath) -> C?
        where C: CellIdentifierType
    {
        return dequeReusableCell(with: type.identifier, for: indexPath) as? C
    }
}

extension UICollectionView: CellRegisterType {
    public func register(_ cellClass: AnyClass?, with identifier: String) {
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }
}

extension UICollectionView: CellDequeType {
    public typealias CellType = UICollectionViewCell

    public func dequeReusableCell(with id: String, for indexPath: IndexPath)
        -> UICollectionViewCell
    {
        return dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
    }
}

extension UITableView: CellRegisterType {
    public func register(_ cellClass: AnyClass?, with identifier: String) {
        register(cellClass, forCellReuseIdentifier: identifier)
    }
}

extension UITableView: CellDequeType {
    public typealias CellType = UITableViewCell
    
    public func dequeReusableCell(with id: String, for indexPath: IndexPath)
        -> UITableViewCell
    {
        return dequeueReusableCell(withIdentifier: id, for: indexPath)
    }
}
