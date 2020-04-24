//
//  Source.swift
//  QuickHatchStream
//
//  Created by Daniel Koster on 4/24/20.
//  Copyright © 2020 Daniel Koster. All rights reserved.
//

import Foundation

public class Source<DataType> {
    private let onEmit: (DataType) -> Void
    private let onError: (Error) -> Void
    private let onClosedHandler: () -> Void
    public init(onEmit: @escaping (DataType) -> Void, onError: @escaping (Error) -> Void, onClosed: @escaping () -> Void) {
        self.onEmit = onEmit
        self.onError = onError
        self.onClosedHandler = onClosed
    }
    public func onEmit(data: DataType) {
        onEmit(data)
    }
    public func onError(error: Error) {
        onError(error)
    }
    public func onClosed() {
        onClosedHandler()
    }
}
