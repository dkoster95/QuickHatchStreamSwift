//
//  Connection.swift
//  QuickHatchStream
//
//  Created by Daniel Koster on 4/24/20.
//  Copyright © 2020 Daniel Koster. All rights reserved.
//

import Foundation

public protocol Connectable {
    func close()
}

public class Connection: Connectable {
    public init(){}
    public func close() {
        
    }
}
