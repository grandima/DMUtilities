//
//  AugmentedTableViewDataSource.swift
//  Shows Tracker
//
//  Created by Dima Medynsky on 4/11/16.
//  Copyright © 2016 Dima Medynsky. All rights reserved.
//

import UIKit

class AugmentedTableViewDataSource<Delegate: DataSourceDelegate, Data: AugmentedDataProvider, Cell: UITableViewCell>:NSObject, UITableViewDataSource where Delegate.Item == Data.Item, Cell: ConfigurableCell, Cell.DataSource == Data.Item {
    
    required init(tableView: UITableView, dataProvider: Data, delegate: Delegate) {
        self.tableView = tableView
        self.dataProvider = dataProvider
        self.delegate = delegate
        super.init()
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    private let tableView: UITableView
    private let dataProvider: Data!
    private var delegate: Delegate!
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataProvider.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataProvider.title(forHeaderInSection: section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = dataProvider.objectAtIndexPath(indexPath)
        let identifier = delegate.cellIdentifierForObject(object)
        guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? Cell
            else { fatalError("Unexpected cell type at \(indexPath)") }
        cell.configureForObject(object)
        return cell
    }
    
    func processUpdates(updates: [DataProviderUpdate<Data.Item>]?) {
        
        guard let updates = updates else { return tableView.reloadData() }
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .Insert(let indexPath):
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            case .Update(let indexPath, let object):
                guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? Cell else { break }
                cell.configureForObject(object)
            case .Move(let indexPath, let newIndexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            case .Delete(let indexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
        tableView.endUpdates()
        
    }
    
}
