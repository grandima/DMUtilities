//
//  UIColorExtension.swift
//  DMShared
//
//  Created by Dima Medynsky on 1/9/17.
//  Copyright © 2017 Dima Medynsky. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
