//
//  DialogViewType.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/27/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

/// UIView subclasses that implement this protocol can be added to
/// UIDialogViewController.
@objc public protocol DialogViewType: class, ViewBuilderType {}

/// Preset DialogViewType that requires long-side paddings.
///
/// UIView instances that implement this protocol will be equally distant
/// from the parent view by the padding values.
@objc public protocol LongSidePaddingDialogViewType: DialogViewType {
    
    /// Padding against the long size. In portrait mode, this represents
    /// horizontal padding, while in landscape mode, vertical padding.
    var longSidePadding: CGFloat { get }
}

/// Preset DialogViewType that requires short-side paddings.
///
/// UIView instances that implement this protocol will be equally distant
/// from the parent view by the padding values.
@objc public protocol ShortSidePaddingDialogViewType: DialogViewType {
    /// Padding against the short side. In portrait mode, this represents
    /// vertical padding, while in landscape mode, horizontal padding.
    var shortSidePadding: CGFloat { get }
}

/// Preset DialogViewType that requires long-side and short-side paddings.
/// UIView instances that implement this protocol will be equally distant
/// from the parent view by the padding values.
@objc public protocol PaddingDialogViewType:
    LongSidePaddingDialogViewType,
    ShortSidePaddingDialogViewType {}

public extension PaddingDialogViewType where Self: UIView {
    
    /// Get an Array of ViewBuilderComponentType based on long-side and
    /// short-side padding values.
    ///
    /// - Parameter view: The view to be attached to.
    /// - Returns: An Array of ViewBuilderComponentType.
    public func builderComponents(for view: UIView) -> [ViewBuilderComponentType] {

    }
}
