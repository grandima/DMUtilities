//
//  Singletone.swift
//  DMShared
//
//  Created by Dima Medynsky on 10/9/16.
//  Copyright © 2016 Dima Medynsky. All rights reserved.
//

import Foundation
public protocol Singletone: class {
    static var sharedInstance: Self { get }
}
