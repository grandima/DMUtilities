//
//  FetchedResultsDataProvider.swift
//  Shows Tracker
//
//  Created by Dima Medynsky on 3/28/16.
//  Copyright © 2016 Dima Medynsky. All rights reserved.
//

import Foundation
import CoreData

class FetchedResultsDataProvider<Delegate: DataProviderDelegate, FetchResult: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate, AugmentedDataProvider {
    
    typealias Item = Delegate.Item
    
    init(fetchedResultsController: NSFetchedResultsController<FetchResult>, delegate: Delegate) {
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        super.init()
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }
    
    func reconfigureFetchRequest( block: (NSFetchRequest<FetchResult>) -> ()) {
        NSFetchedResultsController<FetchResult>.deleteCache(withName: fetchedResultsController.cacheName)
        block(fetchedResultsController.fetchRequest)
        do { try fetchedResultsController.performFetch() } catch { fatalError("fetch request failed") }
        delegate.dataProviderDidUpdate(updates: nil)
    }
    
    func object(at indexPath: IndexPath) -> Item {
        
        guard let result = fetchedResultsController.object(at: indexPath) as? Item else { fatalError("Unexpected object at \(indexPath)") }
        return result
    }
    
    func numberOfItems(in section: Int) -> Int {
        guard let sec = fetchedResultsController.sections?[section] else { return 0 }
        return sec.numberOfObjects
    }
    
    
    // MARK: Private
    
    private let fetchedResultsController: NSFetchedResultsController<FetchResult>
    private weak var delegate: Delegate!
    private var updates: [DataProviderUpdate<Item>] = []
    
    
    // MARK: NSFetchedResultsControllerDelegate
    
    private func controllerWillChangeContent(_ controller: NSFetchedResultsController<FetchResult>) {
        updates = []
    }
    private func controller(_ controller: NSFetchedResultsController<FetchResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError("Index path should be not nil") }
            updates.append(.Insert(indexPath))
        case .update:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            let object = self.object(at: indexPath)
            updates.append(.Update(indexPath, object))
        case .move:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            guard let newIndexPath = newIndexPath else { fatalError("New index path should be not nil") }
            updates.append(.Move(indexPath, newIndexPath))
        case .delete:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            updates.append(.Delete(indexPath))
        }
    }
    
    private func controllerDidChangeContent(controller: NSFetchedResultsController<FetchResult>) {
        delegate.dataProviderDidUpdate(updates: nil)
    }
    
}
