// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 09/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct Capture {
    public let value: Substring
    public let range: Range<String.Index>
    
    init(from text: String, range: NSRange) {
        let start = text.index(text.startIndex, offsetBy: range.location)
        let end = text.index(start, offsetBy: range.length)
        self.range = start ..< end
        self.value = text[start ..< end]
    }
}

public struct Match {
    let captures: [Capture]
    
    init(from text: String, match: NSTextCheckingResult) {
        var captures: [Capture] = []
        for n in 0 ..< match.numberOfRanges {
            captures.append(Capture(from: text, range: match.range(at: n)))
        }
        
        self.captures = captures
    }
    
    public var value: Substring { return captures[0].value }
    public var range: Range<String.Index> { return captures[0].range }
}

public extension NSRegularExpression {
    func substitute(in text: String, process: (String, Match) -> String) -> String {
        var processed = text
        let range = NSRange(location: 0, length: processed.count)
        for nsmatch in matches(in: processed, options: [], range: range).reversed() {
            let match = Match(from: processed, match: nsmatch)
            let replacement = process(processed, match)
            processed = processed.replacingCharacters(in: match.range, with: replacement)
        }
        return processed
    }
}

public extension String {
    func substituting(pattern: String, options: NSRegularExpression.Options = [], process: (String, Match) -> String) -> String {
        let expression = try! NSRegularExpression(pattern: pattern, options: options)
        return expression.substitute(in: self, process: process)
    }
}
