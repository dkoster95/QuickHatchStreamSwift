//
//  QuickHatchStreamTests.swift
//  QuickHatchStreamTests
//
//  Created by Daniel Koster on 4/17/20.
//  Copyright © 2020 Daniel Koster. All rights reserved.
//

import XCTest
@testable import QuickHatchStream

class QuickHatchStreamTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMap() {
        let exp = XCTestExpectation()
        let intStream = QuickHatchStream.Stream<Int> { source in
            source.onEmit(data: 3)
            source.onEmit(data: 2)
            source.onEmit(data: 5)
            source.onEmit(data: 22)
            source.onClosed()
            return Connection()
        }
        _ = intStream
            .filter { $0 % 2 == 0 }
            .map { return "stringStream \($0)"}
            .connect(onEmit: { data in
                XCTAssert(data.contains("stringStream"))
                print(data)
                exp.fulfill()
            }, onError: { error in
                XCTAssert(false)
            })
        wait(for: [exp], timeout: 2.0)
    }
    
    func testFlatMap() {
        let exp = XCTestExpectation()
        let intStream = QuickHatchStream.Stream<Int> { source in
            source.onEmit(data: 3)
            source.onEmit(data: 2)
            source.onEmit(data: 5)
            source.onEmit(data: 22)
            source.onClosed()
            return Connection()
        }
        
        func buildStringStream(value: Int) -> QuickHatchStream.Stream<String> {
            return QuickHatchStream.Stream<String> { source in
                source.onEmit(data: "flatMapped \(value)")
                return Connection()
            }
        }
        _ = intStream
            .filter { $0 % 2 == 0 }
            .flatMap { buildStringStream(value: $0) }
            .connect(onEmit: { data in
                XCTAssert(data.contains("flatMapped"))
                print(data)
                exp.fulfill()
            }, onError: { error in
                XCTAssert(false)
            })
        wait(for: [exp], timeout: 2.0)
    }

}
