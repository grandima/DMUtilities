//
//  Window.swift
//  DMShared
//
//  Created by Dmytro Medynsky on 11/7/16.
//  Copyright © 2016 Dima Medynsky. All rights reserved.
//
import Foundation
import UIKit

open class Window: UIWindow {
    
    override open func makeKeyAndVisible() {
        backgroundColor = .clear
        alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        })
        super.makeKeyAndVisible()
    }
}
