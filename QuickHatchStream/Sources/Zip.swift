//
//  Zip.swift
//  QuickHatchStream
//
//  Created by Daniel Koster on 4/24/20.
//  Copyright © 2020 Daniel Koster. All rights reserved.
//

import Foundation

public extension Stream {
    class func zip<A,B>(streamA: Stream<A>, streamB: Stream<B>) -> Stream<(A,B)> {
        return Stream<(A,B)> { source in
            //let emissionSemaphore = DispatchSemaphore(value: 1)
            let streamsSemaphore = DispatchSemaphore(value: 2)
            streamsSemaphore.wait()
            var valueA: A!
            _ = streamA.connect(onEmit: { data in
                valueA = data
                streamsSemaphore.signal()
            }, onError: { error in
                
            })
            var valueB: B!
            streamsSemaphore.wait()
            _ = streamB.connect(onEmit: { data in
                valueB = data
                streamsSemaphore.signal()
            }, onError: { error in
                
            })
            source.onEmit(data: (valueA, valueB))
            //emissionSemaphore.wait()
            return Connection()
        }
    }
}
