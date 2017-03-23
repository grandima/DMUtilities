//
//  Thread.swift
//  DMShared
//
//  Created by Dima Medynsky on 11/4/16.
//  Copyright © 2016 Dima Medynsky. All rights reserved.
//

import Foundation

extension Thread {
    public static func syncOnMain(mainThreadClosure: @escaping () -> Void) {
        if self.current == self.main {
            mainThreadClosure()
        } else {
            let queue = DispatchQueue.main
            queue.sync(execute: {
                mainThreadClosure()
            })
        }
    }
    public static func asyncOnMain(mainThreadClosure: @escaping () -> Void) {
        if self.current == self.main {
            mainThreadClosure()
        } else {
            let queue = DispatchQueue.main
            queue.async(execute: {
                mainThreadClosure()
            })
        }
    }
}
