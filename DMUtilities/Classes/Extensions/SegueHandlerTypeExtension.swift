//
//  SegueHandlerType.swift
//  DMShared
//
//  Created by Dima Medynsky on 11/19/16.
//  Copyright © 2016 Dima Medynsky. All rights reserved.
//

import UIKit

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    public func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    public func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Couldn't handle segue identifier \(segue.identifier) for view controller of type \(type(of: self)).")
        }
        
        return segueIdentifier
    }
}
