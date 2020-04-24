//
//  ZipTests.swift
//  QuickHatchStreamTests
//
//  Created by Daniel Koster on 4/24/20.
//  Copyright © 2020 Daniel Koster. All rights reserved.
//

import XCTest
@testable import QuickHatchStream

class ZipTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testZip() {
        let intStream = QuickHatchStream.Stream<Int> { source in
            source.onEmit(data: 3)
            source.onEmit(data: 55)
            source.onEmit(data: 2)
            source.onClosed()
            return Connection()
        }
        let stringStream = QuickHatchStream.Stream<String> { source in
            source.onEmit(data: "1st")
            source.onEmit(data: "second")
            source.onEmit(data: "third")
            source.onClosed()
            return Connection()
        }
        let expectation = XCTestExpectation()
        _ = QuickHatchStream.Stream<(Int, String)>.zip(streamA: intStream, streamB: stringStream).connect(onEmit: { (int, string) in
            print("(\(string), \(int))")
            XCTAssert(true)
            expectation.fulfill()
        }, onError: {error in })
    }

}
