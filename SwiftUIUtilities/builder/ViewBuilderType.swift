//
//  ViewBuilderType.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/21/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import UIKit

/// Implement this protocol to provide a UIView subview and a set of
/// NSLayoutConstraints for dynamic view building.
@objc public protocol ViewBuilderComponentType {
    
    /// The child UIView to be added.
    var viewToBeAdded: UIView? { get }
    
    /// Create a set of constraints to add to the parent view, or the subview
    /// itself. This is a closure function instead of a concrete 
    /// NSLayoutConstraint Array because there are cases whereby one subview
    /// may be dependent on another, so with this we can find the latter via
    /// accessibilityIdentifier after all child views have been added. The
    /// closure accepts one argument, which is the current UIView instance
    /// to which subviews are added.
    var layoutConstraints: (UIView) -> [NSLayoutConstraint] { get }
}

/// Implement this protocol to configure views added dynamically by
/// ViewBuilderType.
@objc public protocol ViewBuilderConfigType {
    
    /// Configure the current UIView, after populating it with a
    /// ViewBuilderType. This does not need to be a closure (as is the case
    /// with ViewBuilderComponentType) because by this time all subviews
    /// will have been added, and we can simply search for them using their
    /// accessibilityIdentifier values.
    ///
    /// - Parameter view: The UIView to be configured.
    func configure(for view: UIView)
}

/// Implement this protocol for convenient dynamic view building.
@objc public protocol ViewBuilderType: ViewBuilderConfigType {
    
    /// Get an Array of ViewBuilderComponentType for dynamic view building.
    ///
    /// - Returns: An Array of ViewBuilderComponentType.
    func builderComponents() -> [ViewBuilderComponentType]
}

/// Basic component block for ViewBuilderType.
@objc public class ViewBuilderComponent: NSObject {
    
    /// The subview to be added.
    fileprivate var subview: UIView?
    
    /// Create an Array of NSLayoutConstraints to be added to the parent view 
    /// or the subview itself.
    fileprivate var constraints: (UIView) -> [NSLayoutConstraint]
    
    fileprivate override init() {
        constraints = {_ in []}
    }
    
    /// Builder class for ViewBuilderComponent.
    public class Builder {
        fileprivate let component: ViewBuilderComponent
        
        fileprivate init() {
            component = ViewBuilderComponent()
        }
        
        /// Set subview instance.
        ///
        /// - Parameter view: A UIView instance.
        /// - Returns: The current Builder instance.
        public func with(view: UIView) -> Builder {
            component.subview = view
            return self
        }
        
        
        /// Set the constraints creation closure.
        ///
        /// - Parameter closure: Closure that creates layout constraints.
        /// - Returns: The current builder instance.
        public func with(closure: @escaping (UIView) -> [NSLayoutConstraint])
            -> Builder
        {
            component.constraints = closure
            return self
        }
        
        /// Get component.
        ///
        /// - Returns: An ViewBuilderComponentType instance.
        public func build() -> ViewBuilderComponentType {
            return component
        }
    }
}

public extension ViewBuilderComponent {
    
    /// Use this static variable when we do want to inflate any subview.
    public static let empty = ViewBuilderComponent()
    
    public static func builder() -> Builder {
        return Builder()
    }
}

extension ViewBuilderComponent: ViewBuilderComponentType {
    public var viewToBeAdded: UIView? {
        return subview
    }
    
    public var layoutConstraints: (UIView) -> [NSLayoutConstraint] {
        return constraints
    }
}

public extension UIView {
    
    /// Create a UIView instance and configure it using a ViewBuilderType.
    ///
    /// - Parameters:
    ///   - builder: A ViewBuilderType instance.
    public convenience init(with builder: ViewBuilderType) {
        self.init()
        populateSubviews(with: builder)
        builder.configure(for: self)
    }
    
    /// Populate subviews and constraints from a Array of
    /// ViewBuilderComponentType
    ///
    /// - Parameter components: A Array of ViewBuilderComponentType
    public func populateSubviews(from components: [ViewBuilderComponentType]) {
        let subviews = components.flatMap({$0.viewToBeAdded})

        // Set translatesAutoresizingMaskIntoConstraints to false to avoid
        // unwanted constraints.
        subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        // We first add all subviews.
        subviews.forEach(addSubview)
        
        /// We create the constraints after adding all subviews in order to
        /// access all available subviews.
        let constraints = components.flatMap({$0.layoutConstraints(self)})
        
        // Then we add the layout constraints. Direct constraints will be
        // added to the constraint's firstItem (provided it is a UIView).
        for cs in constraints {
            if cs.isDirectConstraint, let view = cs.firstItem as? UIView {
                view.addConstraint(cs)
            } else {
                addConstraint(cs)
            }
        }
    }
    
    /// Populate subviews with a ViewBuilderType. This method does not
    /// configure the view with builder.configure(view:) in order to keep
    /// it consistent with populateSubviews(from:). The configure(view:) method
    /// should be called separately.
    ///
    /// - Parameter builder: A ViewBuilderType instance.
    public func populateSubviews(with builder: ViewBuilderType) {
        populateSubviews(from: builder.builderComponents())
    }
}
