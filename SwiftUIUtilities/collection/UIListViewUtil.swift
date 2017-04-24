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

public protocol CellRegisterType {
    associatedtype CellType: UIView, CellIdentifierType
    
    /// This method is common to both UICollectionView and UITableView.
    ///
    /// - Parameters:
    ///   - cellClass: Any class object.
    ///   - identifier: A String value.
    func register(_ cellClass: AnyClass?, with identifier: String)
}

public extension CellRegisterType {
    
    /// Register a cell type.
    ///
    /// - Parameter type: A CellType type.
    func register(with type: CellType.Type) {
        register(type.self, with: type.identifier)
    }
}

extension UICollectionView: CellRegisterType {
    public typealias CellType = UICollectionViewCell
    
    public func register(_ cellClass: AnyClass?, with identifier: String) {
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }
}

extension UITableView: CellRegisterType {
    public typealias CellType = UITableViewCell
    
    public func register(_ cellClass: AnyClass?, with identifier: String) {
        register(cellClass, forCellReuseIdentifier: identifier)
    }
}
