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
