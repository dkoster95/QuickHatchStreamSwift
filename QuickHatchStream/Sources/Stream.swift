//
//  Stream.swift
//  QuickHatchStream
//
//  Created by Daniel Koster on 4/17/20.
//  Copyright © 2020 Daniel Koster. All rights reserved.
//

import Foundation

public typealias Task<DataType> = (Source<DataType>) -> Connection



open class Stream<DataType> {
    
    private let task: Task<DataType>
    private let runTaskOn: DispatchQueue
    private let dispatchResultsOn: DispatchQueue
    
    public init(runTaskOn: DispatchQueue = .global(qos: .background), dispatchResultsOn: DispatchQueue = .main, task: @escaping Task<DataType>) {
        self.task = task
        self.runTaskOn = runTaskOn
        self.dispatchResultsOn = dispatchResultsOn
    }
    
    func map<NewType>(transform: @escaping (DataType) throws ->  NewType) -> Stream<NewType> {
        return Stream<NewType> { source in
            return self.connect(onEmit: { data in
                do {
                    try source.onEmit(data: transform(data))
                } catch let error {
                    source.onError(error: error)
                }
            }, onError: { error in
                source.onError(error: error)
            }, onClosed: {
                source.onClosed()
            })
        }
    }
    
    func flatMap<NewType>(transform: @escaping (DataType) throws -> Stream<NewType>) -> Stream<NewType> {
        return Stream<NewType> { source in
            return self.connect(onEmit: { data in
                do {
                    try _ = transform(data).connect(onEmit: { data in
                        source.onEmit(data: data)
                    }, onError: { error in
                        source.onError(error: error)
                    }, onClosed: {
                        source.onClosed()
                    })
                } catch let error {
                    source.onError(error: error)
                }
            },onError: { error in
                source.onError(error: error)
            }, onClosed: {
                source.onClosed()
            })
        }
    }
    
    func filter(query: @escaping (DataType) throws -> Bool) -> Stream<DataType> {
        return Stream<DataType> { source in
            self.connect(onEmit: { data in
                do {
                    if try query(data) {
                        source.onEmit(data: data)
                    }
                } catch let error {
                    source.onError(error: error)
                }
            }, onError: { error in
                source.onError(error: error)
            }, onClosed: {
                source.onClosed()
            })
        }
    }
    
    func connect(onEmit: @escaping (DataType) -> Void, onError: @escaping (Error) -> Void, onClosed: (() -> Void)? = nil) -> Connection {
        return task(Source<DataType>(onEmit: { data in
            onEmit(data)
        }, onError: { error in
                onError(error)
        },onClosed: {
            onClosed?()
        }))
    }
}





