// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 07/12/2018.
//  All code (c) 2018 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
@testable import Expressions

class ExpressionTests: XCTestCase {
    
    let positionalCapturePattern = try! NSRegularExpression(pattern: #"(\w+) (.*) (\w+)"#, options: [])
    
    let namedCapturePattern = try! NSRegularExpression(pattern: #"""
(?xi)
(?<first>   \w+ ) ?(?-x: )
(?<number>  .*  ) ?(?-x: )
(?<last>    \w+ )
"""#, options: [])

    
    func testReturnedResults() {
        struct Result: Constructable {
            var first = ""
            var last = ""
            var number = 0
        }
        
        if let match: Result = positionalCapturePattern.firstMatch(in: "Sam 123 Deane", capturing: [\Result.first: 1, \Result.last: 3, \Result.number: 2]) {
            XCTAssertEqual(match.first, "Sam")
            XCTAssertEqual(match.last, "Deane")
            XCTAssertEqual(match.number, 123)
        }
    }
    
    func testPassedInResults() {
        struct Result {
            var first = ""
            var last = ""
            var number = 0
        }
        
        var result = Result()
        if positionalCapturePattern.firstMatch(in: "Sam 123 Deane", capturing: [\Result.first: 1, \Result.last: 3, \Result.number: 2], into: &result) {
            XCTAssertEqual(result.first, "Sam")
            XCTAssertEqual(result.last, "Deane")
            XCTAssertEqual(result.number, 123)
        }
    }
    
    func testPassedInResultsNoMatch() {
        struct Result {
            var first = ""
            var last = ""
            var number = 0
        }
        
        var result = Result()
        XCTAssertFalse(positionalCapturePattern.firstMatch(in: "Wrong", capturing: [\Result.first: 1, \Result.last: 3, \Result.number: 2], into: &result))
    }
    

    func testNamedCapture() {
        #if canImport(ObjectiveC)
        class Result: NSObject {
            @objc var first = ""
            @objc var last = ""
            @objc var number = 0
        }
        
        if let result: Result = namedCapturePattern.firstMatch(in: "Sam 123 Deane") {
            XCTAssertEqual(result.first, "Sam")
            XCTAssertEqual(result.last, "Deane")
            XCTAssertEqual(result.number, 123)
        }
        #endif
    }

    func testNamedCapturePassedIn() {
        #if canImport(ObjectiveC)
        class Result: NSObject {
            @objc var first = ""
            @objc var last = ""
            @objc var number = 0
        }
        
        var result = Result()
        if namedCapturePattern.firstMatch(in: "Sam 123 Deane", capturing: &result) {
            XCTAssertEqual(result.first, "Sam")
            XCTAssertEqual(result.last, "Deane")
            XCTAssertEqual(result.number, 123)
        }
        #endif
    }
}
