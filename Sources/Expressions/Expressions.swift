// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/12/2018.
//  All code (c) 2018 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

/**
 A protocol that result types need to conform to in order for them to
 be useable with methods that create and return instances of them.
 
 This is necessary because there is no standard way to express that a type
 must be constructable with an initialiser that takes no parameters
 (ideally this would be a standard swift protocol that types
 automatically conformed to if they matched the criteria)
 */

public protocol Constructable {
    init()
}

public extension NSRegularExpression {
    
    /**
     Unpack a reg-exp match into a result structure.
    */
    
    fileprivate func unpack<T>(_ match: NSTextCheckingResult, mappings: [PartialKeyPath<T> : Int], string: String, into: inout T) {
        for mapping in mappings {
            if let range = Range(match.range(at: mapping.value), in: string) {
                if let path = mapping.key as? WritableKeyPath<T,String> {
                    let captured = String(string[range])
                    into[keyPath: path] = captured
                } else if let path = mapping.key as? WritableKeyPath<T,Int> {
                    let captured = (String(string[range]) as NSString).integerValue
                    into[keyPath: path] = captured
                }
            }
        }
    }
    
    /**
     Finds the first match of the expression in the given string.
     Uses the mappings to fill in a result instance, which is returned.
 
     Because this method constructs the result instance, the instance type needs to conform to
     `Constructable`.
     
     @param in The string to search.
     @param mappings A dictionary mapping key paths in the result type to capture groups in the expression.
    */
    
    func firstMatch<T: Constructable>(in string: String, capturing mappings: [PartialKeyPath<T>:Int]) -> T? {
        let range = NSRange(location: 0, length: string.count)
        if let match = firstMatch(in: string, options: [], range: range) {
            var result = T()
            unpack(match, mappings: mappings, string: string, into: &result)
            return result
        }
        return nil
    }

    /**
     Finds the first match of the expression in the given string.
     Uses the mappings to fill in the passed-in result instance.

     Because this variation fills in a passed-in result structure, it doesn't need to construct it. This
     avoids the structure having to conform to `Constructable`.
     
     @param in The string to search.
     @param mappings A dictionary mapping key paths in the result type to capture groups in the expression.
     @param info The structure to return the capture results in.
     */

    func firstMatch<T>(in string: String, capturing mappings: [PartialKeyPath<T>:Int], into capture: inout T) -> Bool {
        let range = NSRange(location: 0, length: string.count)
        if let match = firstMatch(in: string, options: [], range: range) {
            unpack(match, mappings: mappings, string: string, into: &capture)
            return true
        }
        
        return false
    }
    
    /**
     Finds the first match of the expression in the given string.
     Uses Swift reflection to fill in the passed-in result instance, by looking for named capture groups
     that match the names of properties in the instance.
     
     Because this method constructs the result instance, the instance type needs to conform to
     `Constructable`.
     
     Because it relies on named capture groups, the regular expression needs to use them.

     Because Swift reflection currently only supports read-only access, we have to use Objective-C
     key-value support to write into the result instance. This means that any captured properties have
     to be annotated with @objc, as does the structure itself.
     
     @param in The string to search.
     */

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

    
    /**
     Finds the first match of the expression in the given string.
     Uses Swift reflection to fill in the passed-in result instance, by looking for named capture groups
     that match the names of properties in the instance.
     
     Because this variation fills in a passed-in result structure, it doesn't need to construct it. This
     avoids the structure having to conform to `Constructable`.

     Because it relies on named capture groups, the regular expression needs to use them.
     
     Because Swift reflection currently only supports read-only access, we have to use Objective-C
     key-value support to write into the result instance. This means that any captured properties have
     to be annotated with @objc, as does the structure itself.
     
     @param in The string to search.
     @param result The
     */
    
    @available(macOS 10.13, iOS 10.0, *) func firstMatch<T>(in string: String, capturing: inout T) -> Bool where T: NSObject {
        let over = NSRange(location: 0, length: string.count)
        if let match = firstMatch(in: string, options: [], range: over) {
            let mirror = Mirror(reflecting: capturing)
            for child in mirror.children {
                if let name = child.label {
                    let range = match.range(withName: name)
                    let value = (string as NSString).substring(with: range)
                    switch child.value {
                    case is String:
                        capturing.setValue(value, forKey: name)
                    case is Int:
                        capturing.setValue((value as NSString).integerValue, forKey: name)
                    default:
                        break
                    }
                }
            }
            return true
        }
        
        return false
    }

}
