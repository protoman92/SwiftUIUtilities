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
    func registerClass(_ cellClass: AnyClass?, with identifier: String)
    
    /// This method is common to both UICollectionView and UITableView.
    ///
    /// - Parameters:
    ///   - nib: A UINib instance.
    ///   - identifier: A String value.
    func registerNib(_ nib: UINib?, with identifier: String)
    
    /// Deque a cell with an identifier.
    ///
    /// - Parameters:
    ///   - id: A String value.
    ///   - at: An IndexPath instance.
    /// - Returns: A CellType istance.
    func dequeReusableCell(_ id: String, at indexPath: IndexPath) -> CellType
}

public extension CellOwnerType {
    
    /// Register a cell type.
    ///
    /// - Parameter type: The C class type.
    public func registerClass<C>(_ type: C.Type) where
        C: UIView, C: CellIdentifiableType
    {
        registerClass(type.self, with: type.identifier)
    }
    
    /// Register a nib.
    ///
    /// - Parameters:
    ///   - type: The C class type.
    ///   - bundle: A Bundle instance.
    public func registerNib<C>(_ type: C.Type, bundle: Bundle? = nil) where
        C: UIView, C: CellIdentifiableType
    {
        let identifier = type.identifier
        let nib = UINib(nibName: identifier, bundle: bundle)
        registerNib(nib, with: identifier)
    }
    
    /// Deque a cell with a CellIdentifiableType subclass.
    ///
    /// - Parameters:
    ///   - type: A CellIdentifierType subclass type.
    ///   - indexPath: An IndexPath instance.
    /// - Returns: An optional CellIdentifierType instance.
    public func deque<C>(_ type: C.Type, at indexPath: IndexPath) -> C?
        where C: CellIdentifiableType
    {
        return dequeReusableCell(type.identifier, at: indexPath) as? C
    }
}

extension UICollectionView: CellOwnerType {
    public typealias CellType = UICollectionViewCell
    
    public func registerClass(_ cellClass: AnyClass?, with identifier: String) {
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    public func registerNib(_ nib: UINib?, with identifier: String) {
        register(nib, forCellWithReuseIdentifier: identifier)
    }

    public func dequeReusableCell(_ id: String, at indexPath: IndexPath)
        -> UICollectionViewCell
    {
        return dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
    }
}

extension UITableView: CellOwnerType {
    public typealias CellType = UITableViewCell
    
    public func registerClass(_ cellClass: AnyClass?, with identifier: String) {
        register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    public func registerNib(_ nib: UINib?, with identifier: String) {
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    public func dequeReusableCell(_ id: String, at indexPath: IndexPath)
        -> UITableViewCell
    {
        return dequeueReusableCell(withIdentifier: id, for: indexPath)
    }
}
