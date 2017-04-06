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
    
    func object(at indexPath: IndexPath) -> Item
    
    func numberOfItems(in section: Int) -> Int
}


protocol AugmentedDataProvider: DataProvider {
    var numberOfSections: Int { get }
    func titleForHeader(in section: Int) -> String?
}
extension AugmentedDataProvider {
    var numberOfSections: Int { return 1 }
    func titleForHeader(in section: Int) -> String? { return nil }
}

protocol DataProviderDelegate: class {
    associatedtype Item: Any
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Item>]?)
}

enum DataProviderUpdate<Object> {
    case Insert(IndexPath)
    case Update(IndexPath, Object)
    case Move(IndexPath, IndexPath)
    case Delete(IndexPath)
}
