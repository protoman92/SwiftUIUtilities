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
    
    /// The set of constraints to add to the parent view, or the subview
    /// itself.
    var layoutConstraints: [NSLayoutConstraint] { get }
}

/// Implement this protocol to configure views added dynamically by
/// ViewBuilderType.
@objc public protocol ViewBuilderConfigType {
    
    /// Configure the current UIView, after populating it with a
    /// ViewBuilderType.
    ///
    /// - Parameter view: The UIView to be configured.
    func configure(for view: UIView)
}

/// Implement this protocol for convenient dynamic view building.
@objc public protocol ViewBuilderType: ViewBuilderConfigType {
    
    /// Get an Array of ViewBuilderComponentType for dynamic view building.
    ///
    /// - Parameters:
    ///   - view: The parent UIView to attach.
    /// - Returns: An Array of ViewBuilderComponentType.
    func builderComponents(for view: UIView) -> [ViewBuilderComponentType]
}

/// Basic component block for ViewBuilderType.
@objc public class ViewBuilderComponent: NSObject {
    
    /// The subview to be added.
    fileprivate var subview: UIView?
    
    /// An Array of NSLayoutConstraints to be added to the parent view or the
    /// subview itself.
    fileprivate var constraints: [NSLayoutConstraint]
    
    fileprivate override init() {
        constraints = []
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
        
        /// Add a layout constraint.
        ///
        /// - Parameter constraint: An optional NSLayoutConstraint instance.
        /// - Returns: The current Builder instance.
        public func add(constraint: NSLayoutConstraint?) -> Builder {
            if let constraint = constraint {
                component.constraints.append(constraint)
            }
            
            return self
        }
        
        /// Add vararg layout constraints.
        ///
        /// - Parameter constraint: A vararg of NSLayoutConstraint instances.
        /// - Returns: The current Builder instance.
        public func add(constraints: NSLayoutConstraint...) -> Builder {
            component.constraints.append(contentsOf: constraints)
            return self
        }
        
        /// Add a Sequence of constraints.
        ///
        /// - Parameter constraints: A Sequence of NSLayoutConstraint instances.
        /// - Returns: The current Builder instance.
        public func add<S: Sequence>(constraints: S) -> Builder
            where S.Iterator.Element == NSLayoutConstraint
        {
            component.constraints.append(contentsOf: constraints)
            return self
        }
        
        /// Add a Sequence of NSLayoutConstraint subclass instances.
        ///
        /// - Parameter constraints: A Sequence of NSLayoutConstraint instances.
        /// - Returns: The current Builder instance.
        public func add<S: Sequence>(constraints: S) -> Builder
            where S.Iterator.Element: NSLayoutConstraint
        {
            return add(constraints: constraints.map({$0 as NSLayoutConstraint}))
        }
        
        /// Set constraints Array.
        ///
        /// - Parameter constraints: An Array of NSLayoutConstraint.
        /// - Returns: The current Builder instance.
        public func with(constraints: [NSLayoutConstraint]) -> Builder {
            component.constraints = constraints
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
    
    public var layoutConstraints: [NSLayoutConstraint] {
        return constraints
    }
}

public extension UIView {
    
    /// Create a UIView instance using a ViewBuilderType.
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
        let constraints = components.flatMap({$0.layoutConstraints})

        // Set translatesAutoresizingMaskIntoConstraints to false to avoid
        // unwanted constraints.
        subviews.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        // We first add all subviews.
        subviews.forEach(addSubview)
        
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
    
    /// Populate subviews with a ViewBuilderType.
    ///
    /// - Parameter builder: A ViewBuilderType instance.
    public func populateSubviews(with builder: ViewBuilderType) {
        populateSubviews(from: builder.builderComponents(for: self))
    }
}
