//
//  DataSourceDelegate.swift
//  Series
//
//  Created by Dima Medynsky on 2/26/16.
//  Copyright © 2016 Dima Medynsky. All rights reserved.
//

import Foundation
protocol DataSourceDelegate: class {
    associatedtype Item
    func cellIdentifier(for object: Item) -> String
}

