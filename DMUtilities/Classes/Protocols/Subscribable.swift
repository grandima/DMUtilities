//
//  Subscribable.swift
//  DMShared
//
//  Created by Dima Medynsky on 12/28/16.
//  Copyright © 2016 Dima Medynsky. All rights reserved.
//

import Foundation

public protocol Subsribable: class {
    func subscribeToNotifications()
    func unsubscribeFromNotifications()
}
extension Subsribable where Self: Any {
    public func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
