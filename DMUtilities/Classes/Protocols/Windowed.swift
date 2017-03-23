//
//  Windowed.swift
//  DMShared
//
//  Created by Dmytro Medynsky on 11/7/16.
//  Copyright © 2016 Dima Medynsky. All rights reserved.
//

import Foundation

public protocol Windowed: class {
    static var storyboardName: String { get }
    static var myWindow: UIWindow! { get set }
    
    static func show() -> UIViewController?
    static func destroy()
    
}

extension Windowed {
    static var window: UIWindow? {
        if (myWindow != nil) {
            return myWindow
        } else {
        
            let window = Window(frame: UIScreen.main.bounds)
            let bundle = Bundle.main
            let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
            guard let viewController = storyboard.instantiateInitialViewController() else {
                return nil
            }
            window.windowLevel = UIWindowLevelAlert
            window.rootViewController = viewController
            myWindow = window
            return window
        }
    }
    
    public static func show() -> UIViewController? {
        window?.makeKeyAndVisible()
        return window?.rootViewController
    }
    
    public static func destroy() {
        if (myWindow != nil) {
            myWindow.rootViewController = nil
            myWindow.isHidden = true
            myWindow = nil
        }
    }
    func dismiss() {
        Thread.asyncOnMain {
            UIView.animate(withDuration: 0.3, animations: {
                Self.myWindow.alpha = 0
            }, completion: { (finished) in
                Self.destroy()
            })
        }
    }
}
