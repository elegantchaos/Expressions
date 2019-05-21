// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/12/2018.
//  All code (c) 2018 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
@testable import Expressions

class ExpressionTests: XCTestCase {
    
    func testReturnedResults() {
        struct Result: Constructable {
            var first = ""
            var last = ""
            var number = 0
        }
        
        let pattern = try! NSRegularExpression(pattern: "(\\w+) (.*) (\\w+)", options: [])
        
        if let match: Result = pattern.firstMatch(in: "Sam 123 Deane", capturing: [\Result.first: 1, \Result.last: 3, \Result.number: 2]) {
            XCTAssertEqual(match.first, "Sam")
            XCTAssertEqual(match.last, "Deane")
            XCTAssertEqual(match.number, 123)
        }
    }
    
    func testPassedInResults() {
        class Result {
            var first = ""
            var last = ""
            var number = 0
        }
        
        let pattern = try! NSRegularExpression(pattern: "(\\w+) (.*) (\\w+)", options: [])
        var result = Result()
        if pattern.firstMatch(in: "Sam 123 Deane", capturing: [\Result.first: 1, \Result.last: 3, \Result.number: 2], into: &result) {
            XCTAssertEqual(result.first, "Sam")
            XCTAssertEqual(result.last, "Deane")
            XCTAssertEqual(result.number, 123)
        }
    }
    
    func testPassedInResultsNoMatch() {
        class Result {
            var first = ""
            var last = ""
            var number = 0
        }
        
        let pattern = try! NSRegularExpression(pattern: "(\\w+) (.*) (\\w+)", options: [])
        var result = Result()
        XCTAssertFalse(pattern.firstMatch(in: "Wrong", capturing: [\Result.first: 1, \Result.last: 3, \Result.number: 2], into: &result))
    }
    
    @available(macOS 10.13, iOS 10.0, *) func testReflection() {
        @objc class Result: NSObject {
            @objc var first = ""
            @objc var last = ""
            @objc var number = 0
        }
        
        let pattern = try! NSRegularExpression(pattern: #"""
(?xi)
(?<first>   \w+ ) ?(?-x: )
(?<number>  .*  ) ?(?-x: )
(?<last>    \w+ )
"""#, options: [])

        if let result: Result = pattern.firstMatch(in: "Sam 123 Deane") {
            XCTAssertEqual(result.first, "Sam")
            XCTAssertEqual(result.last, "Deane")
            XCTAssertEqual(result.number, 123)
        }

    }
}
