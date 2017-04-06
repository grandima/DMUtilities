//
//  ConfigurableCell.swift
//  Series
//
//  Created by Dima Medynsky on 2/25/16.
//  Copyright © 2016 Dima Medynsky. All rights reserved.
//

import Foundation

protocol ConfigurableCell {
    associatedtype Entity
    func configure(for object: Entity)
}
