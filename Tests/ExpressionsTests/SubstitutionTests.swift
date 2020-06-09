// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 09/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
@testable import Expressions

class SubstitutionTests: XCTestCase {
    func testMultipleSubstitutionGettingLonger() {
        // test that multiple substitutions work ok when the replacement makes the string longer
        let result = "short blah short".substituting(pattern: #"short"#) { text, match in
            return "longer"
        }
        
        XCTAssertEqual(result, "longer blah longer")
    }

    func testMultipleSubstitutionGettingShorter() {
        // test that multiple substitutions work ok when the replacement makes the string shorter
        let result = "longer blah longer".substituting(pattern: #"longer"#) { text, match in
            return "short"
        }
        
        XCTAssertEqual(result, "short blah short")
    }

    func testUsingMainMatch() {
        let result = "40 and 20".substituting(pattern: #"\d+"#) { text, match in
            let number = Int(match.value)!
            return "half of \(number) is \(number/2)"
        }

        XCTAssertEqual(result, "half of 40 is 20 and half of 20 is 10")
    }

    func testUsingCaptures() {
        let result = "40 and 20".substituting(pattern: #"(\d+) and (\d+)"#) { text, match in
            let number1 = Int(match.captures[1].value)!
            let number2 = Int(match.captures[2].value)!
            return "half of \(number1) is \(number1/2) and twice \(number2) is \(number2*2)"
        }

        XCTAssertEqual(result, "half of 40 is 20 and twice 20 is 40")
    }

}
