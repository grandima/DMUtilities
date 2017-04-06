//
//  TableViewDataSource.swift
//  Series
//
//  Created by Dima Medynsky on 2/26/16.
//  Copyright © 2016 Dima Medynsky. All rights reserved.
//

import UIKit
class TableViewDataSource<Delegate: DataSourceDelegate, Data: AugmentedDataProvider, Cell: UITableViewCell>: NSObject, UITableViewDataSource where Delegate.Item == Data.Item, Cell: ConfigurableCell, Cell.Entity == Data.Item {
    
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
    private weak var delegate: Delegate!
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataProvider.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataProvider.titleForHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = dataProvider.object(at: indexPath)
        let identifier = delegate.cellIdentifier(for: object)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell
            else { fatalError("Unexpected cell type at \(indexPath)") }
        cell.configure(for: object)
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataProvider.numberOfSections
    }
    

    
    func processUpdates(updates: [DataProviderUpdate<Data.Item>]?) {

        guard let updates = updates else { return tableView.reloadData() }
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .Insert(let indexPath):
                tableView.insertRows(at: [indexPath], with: .fade)
            case .Update(let indexPath, let object):
                guard let cell = tableView.cellForRow(at: indexPath) as? Cell else { break }
                cell.configure(for: object)
            case .Move(let indexPath, let newIndexPath):
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.insertRows(at: [newIndexPath], with: .fade)
            case .Delete(let indexPath):
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        tableView.endUpdates()

    }

}
