// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/12/2018.
//  All code (c) 2018 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol RegularExpressionResult {
    init()
}

public extension NSRegularExpression {
    func firstMatch<T: RegularExpressionResult>(of string: String, capturing mappings: [PartialKeyPath<T>:Int]) -> T? {
        let range = NSRange(location: 0, length: string.count)
        if let match = firstMatch(in: string, options: [], range: range) {
            var result = T()
            for mapping in mappings {
                if let range = Range(match.range(at: mapping.value), in: string) {
                    if let path = mapping.key as? WritableKeyPath<T,String> {
                        let captured = String(string[range])
                        result[keyPath: path] = captured
                    } else if let path = mapping.key as? WritableKeyPath<T,Int> {
                        let captured = (String(string[range]) as NSString).integerValue
                        result[keyPath: path] = captured
                    }
                }
            }
            return result
        }
        return nil
    }
    
    func firstMatch<T>(of string: String, capturing mappings: [PartialKeyPath<T>:Int], into capture: inout T) -> Bool {
        let range = NSRange(location: 0, length: string.count)
        if let match = firstMatch(in: string, options: [], range: range) {
            for mapping in mappings {
                if let range = Range(match.range(at: mapping.value), in: string) {
                    if let path = mapping.key as? ReferenceWritableKeyPath<T,String> {
                        capture[keyPath: path] = String(string[range])
                    } else if let path = mapping.key as? ReferenceWritableKeyPath<T,Int> {
                        capture[keyPath: path] = (String(string[range]) as NSString).integerValue
                    }
                }
            }
            return true
        }
        
        return false
    }
    
    @available(macOS 10.13, iOS 10.0, *) func firstMatch<T>(in string: String) -> T? where T: NSObject {
        let over = NSRange(location: 0, length: string.count)
        if let match = firstMatch(in: string, options: [], range: over) {
            let result = T()
            let mirror = Mirror(reflecting: result)
            for child in mirror.children {
                if let name = child.label {
                    let range = match.range(withName: name)
                    let value = (string as NSString).substring(with: range)
                    switch child.value {
                    case is String:
                        result.setValue(value, forKey: name)
                    case is Int:
                        result.setValue((value as NSString).integerValue, forKey: name)
                    default:
                        break
                    }
                }
            }
            return result
        }
        
        return nil
    }
}
