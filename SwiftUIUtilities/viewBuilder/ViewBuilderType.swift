//
//  ViewBuilderType.swift
//  SwiftInputView
//
//  Created by Hai Pham on 4/21/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Implement this protocol to provide a UIView subview and a set of
/// NSLayoutConstraints for dynamic view building.
public protocol ViewBuilderComponentType {
    
    /// The child UIView to be added.
    var viewToBeAdded: UIView? { get }
    
    /// The set of constraints to add to the parent view, or the subview 
    /// itself.
    var layoutConstraints: [NSLayoutConstraint] { get }
}

/// Implement this protocol for convenient dynamic view building.
public protocol ViewBuilderType {
    
    /// Get an Array of ViewBuilderComponentType for dynamic view building.
    ///
    /// - Parameters:
    ///   - view: The parent UIView to attach.
    ///   - input: An InputDetailType instance.
    /// - Returns: An Array of ViewBuilderComponentType.
    func components(for view: UIView, using input: InputDetailType)
        -> [ViewBuilderComponentType]
}

/// Basic component block for ViewBuilderType.
public struct ViewBuilderComponent {
    
    /// The subview to be added.
    fileprivate var subview: UIView?
    
    /// An Array of NSLayoutConstraints to be added to the parent view or the
    /// subview itself.
    fileprivate var constraints: [NSLayoutConstraint]
    
    fileprivate init() {
        constraints = []
    }
    
    /// Builder class for ViewBuilderComponent.
    public class Builder {
        fileprivate var component: InflatorComponent
        
        fileprivate init() {
            component = InflatorComponent()
        }
        
        /// Set subview instance.
        ///
        /// - Parameter view: A UIView instance.
        /// - Returns: The current Builder instance.
        public func with(view: UIView) -> Builder {
            component.subview = view
            return self
        }
        
        /// Add vararg layout constraints.
        ///
        /// - Parameter constraint: A vararg of NSLayoutConstraint instances.
        /// - Returns: The current Builder instance.
        public func add(constraint: NSLayoutConstraint...) -> Builder {
            component.constraints.append(contentsOf: constraint)
            return self
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
        /// - Returns: An InflatorComponentType instance.
        public func build() -> InflatorComponentType {
            return component
        }
    }
}

public extension ViewBuilderComponent {
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
    
    /// Populate subviews and constraints from a Sequence of 
    /// ViewBuilderComponentType
    ///
    /// - Parameter components: A Sequence of ViewBuilderComponentType
    public func populateSubviews<S: Sequence>(from components: S)
        where S.Iterator.Element: ViewBuilderComponentType
    {
        let subviews = components.map({$0.viewToBeAdded})
        let constraints = components.flatMap({$0.layoutConstraints})
        
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
}
