//
//  ViewUtil.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/17/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import UIKit

/// Catch-all completion closure for animations.
public typealias AnimationComplete = (Bool) -> Void

public extension UIView {
    
    /// Get all subviews for the current UIView. This method will be 
    /// recursively called until the UIViews at the bottom of the hierarchy 
    /// are reached.
    public var allSubviews: [UIView] {
        var subviewSet = Set<UIView>()
        allSubviews(forEach: {subviewSet.insert($0)})
        return subviewSet.map({$0})
    }
    
    
    /// Get the rootView of the current view hierarchy. For example, in a
    /// UIViewController, the rootView is the controller's master UIView.
    public var rootView: UIView {
        var rootView = self
        
        while let view = rootView.superview {
            rootView = view
        }
        
        return rootView
    }
    
    /// Call a method on all of the current UIView's subviews. This method
    /// will be recursively called until the UIViews at the bottom of the
    /// hierarchy are reached.
    ///
    /// - Parameter action: Closure that will take each subview as a parameter.
    public func allSubviews(forEach action: (UIView) -> Void) {
        subviews.forEach({
            action($0)
            $0.allSubviews(forEach: action)
        })
    }
    
    /// Get all subviews of a certain type. This method is called recursively,
    /// so performance may be an issue.
    ///
    /// - Parameter type: The type to be checked.
    /// - Returns: An Array of UIView instances that satisfy the condition.
    public func allSubviews<T: UIView>(ofType type: T.Type) -> [T] {
        return allSubviews.flatMap({$0 as? T})
    }
}

public extension UIView {

    /// Get subviews of a certain type.
    ///
    /// - Parameter type: The type to be checked.
    /// - Returns: An Array of UIView instances that satisfy the condition.
    public func subviews<T>(ofType type: T.Type) -> [T] {
        return subviews.flatMap({$0 as? T})
    }
    
    /// Get the first subview that is of a certain type.
    ///
    /// - Parameter type: The type to be checked.
    /// - Returns: An optional UIView that satisfies the condition.
    public func firstSubview<T>(ofType type: T.Type) -> T? {
        for view in subviews {
            if view is T {
                return view as? T
            } else if let child = view.firstSubview(ofType: type) {
                return child
            }
        }
        
        return nil
    }
}

public extension UIView {
    
    /// Get the current UIView's height constraint.
    public var heightConstraint: NSLayoutConstraint? {
        return constraints.filter({
            $0.firstItem as? UIView == self &&
            $0.firstAttribute == .height &&
            $0.secondAttribute == .notAnAttribute
        }).first
    }
    
    /// Get the current UIView's width constraint.
    public var widthConstraint: NSLayoutConstraint? {
        return constraints.filter({
            $0.firstItem as? UIView == self &&
            $0.firstAttribute == .width &&
            $0.secondAttribute == .notAnAttribute
        }).first
    }
    
    /// Get the first constraint with a specified identifier.
    ///
    /// - Parameter identifier: A String value.
    /// - Returns: A NSLayoutConstraint instance.
    public func firstConstraint(withIdentifier identifier: String)
        -> NSLayoutConstraint?
    {
        return constraints.filter({$0.identifier == identifier}).first
    }
}

public extension UIView {
    
    /// Initialize a UIView with a Nib file. We can either specify the file
    /// name, or leave it as default, after which the class name will be
    /// used to look for the file.
    ///
    /// - Parameter named: An optional String value.
    func initializeWithNib(_ named: String? = nil) {
        let cls: AnyClass = classForCoder
        
        guard subviews.count == 0,
            let view = UINib(nibName: named ?? String(describing: cls),
                             bundle: Bundle(for: cls))
                .instantiate(withOwner: self, options: nil).first as? UIView
        else {
            return
        }
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}

public extension UIView {
    
    /// Toggle visibility for the current UIView instance, by animation its
    /// alpha property to the appropriate values, and setting isHidden to
    /// true/false at the right time.
    ///
    /// - Parameters:
    ///   - visible: A Bool value.
    ///   - duration: An optional TimeInstance value.
    ///   - complete: Completion closure.
    public func toggleVisible(
        toBe visible: Bool,
        withDuration duration: TimeInterval? = nil,
        then complete: AnimationComplete? = nil
    ) {
        let duration = duration ?? Duration.short.rawValue
        
        if visible { isHidden = false }
        
        UIView.animate(
            withDuration: duration,
            animations: {self.alpha = visible ? 1 : 0}
        ) {
            if !visible { self.isHidden = true }
            complete?($0)
        }
    }
    
    /// Toggle visibility reactively.
    ///
    /// - Parameters:
    ///   - visible: A Bool value.
    ///   - duration: An optional TimeInstance value.
    /// - Returns: An Observable instance.
    public func rxToggleVisible(
        toBe visible: Bool,
        withDuration duration: TimeInterval? = nil
    ) -> Observable<Bool> {
        return Observable
            .create({observer in
                self.toggleVisible(toBe: visible, withDuration: duration) {
                    observer.onNext($0)
                    observer.onCompleted()
                }
                
                return Disposables.create()
            })
    }
}

public extension UIView {
    
    /// Replace one NSLayoutConstraint with another.
    ///
    /// - Parameters:
    ///   - constraint: The constraint to be replaced.
    ///   - another: The constraint that will be inserted.
    public func replaceConstraint(_ constraint: NSLayoutConstraint,
                                  with another: NSLayoutConstraint) {
        removeConstraint(constraint)
        addConstraint(another)
    }
    
    /// Reactively replace one NSLayoutConstraint with another.
    ///
    /// - Parameters:
    ///   - constraint: The constraint to be replaced.
    ///   - another: The constraint that will be inserted.
    /// - Returns: An Observable instance.
    public func rxReplaceConstraint(_ constraint: NSLayoutConstraint,
                                    with another: NSLayoutConstraint)
        -> Observable<Bool>
    {
        return Completable
            .create(subscribe: {
                self.replaceConstraint(constraint, with: another)
                $0(.completed)
                return Disposables.create()
            })
            .asObservable()
            .map({_ in true})
            .ifEmpty(default: true)
    }
}

public extension UIView {
    
    /// Take a snapshop within a CGRect and produce a UIImage.
    ///
    /// - Parameter frame: The CGRect within which the image is to be taken.
    /// - Returns: An optional UIImage instance.
    public func takeSnapshot(within frame: CGRect? = nil) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        let frame = frame ?? self.frame
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        context.translateBy(x: frame.origin.x * -1, y: frame.origin.y * -1)
        self.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// Take a snapshot reactively, and return an empty Observable if the
    /// image is not available.
    ///
    /// - Parameter frame: The CGRect within which the image is to be taken.
    /// - Returns: An Observable instance.
    public func rxTakeSnapShop(within frame: CGRect? = nil)
        -> Observable<UIImage>
    {
        guard let image = takeSnapshot(within: frame) else {
            return Observable.empty()
        }
        
        return Observable.just(image)
    }
}
