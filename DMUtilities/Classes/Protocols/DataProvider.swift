//
//  DataProvider.swift
//  Series
//
//  Created by Dima Medynsky on 2/26/16.
//  Copyright © 2016 Dima Medynsky. All rights reserved.
//

import Foundation

protocol DataProvider: class {
    associatedtype Item
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> Item
    
    func numberOfItemsInSection(section: Int) -> Int
}


protocol AugmentedDataProvider: DataProvider {
    func numberOfSections() -> Int
    func title(forHeaderInSection section: Int) -> String?
}

protocol DataProviderDelegate: class {
    associatedtype Item: AnyObject
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Item>]?)
}

enum DataProviderUpdate<Object> {
    case Insert(NSIndexPath)
    case Update(NSIndexPath, Object)
    case Move(NSIndexPath, NSIndexPath)
    case Delete(NSIndexPath)
}
