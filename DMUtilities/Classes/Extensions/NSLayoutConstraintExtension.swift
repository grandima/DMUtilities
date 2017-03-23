//
//  NSLayoutConstraintExtension.swift
//  DMShared
//
//  Created by Dima Medynsky on 12/24/16.
//  Copyright © 2016 Dima Medynsky. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    public func multiply(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: firstItem, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: constant)
    }
}
