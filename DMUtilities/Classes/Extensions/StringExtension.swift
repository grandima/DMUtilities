//
//  String.swift
//  DMShared
//
//  Created by Dima Medynsky on 11/5/16.
//  Copyright © 2016 Dima Medynsky. All rights reserved.
//

import Foundation

extension String {
    
    public func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
     public func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
