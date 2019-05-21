# Expressions

Some utilities to make it a little easier to work with regular expressions in Swift when they have capture groups in them.

## Positional Captures

Let's say we have a regular expression `(\w+) (.*) (\w+)`, and a structure that we want to unpack expression matches into:

```
class Result {
var first = ""
var last = ""
var number = 0
}
```

We can match an expression and capture the results like this:

```
let pattern = try! NSRegularExpression(pattern: "(\\w+) (.*) (\\w+)", options: [])
var result = Result()
if pattern.firstMatch(in: "Sam 123 Deane", capturing: [\Result.first: 1, \Result.last: 3, \Result.number: 2], into: &result) {
    // result now contains the captured parameters
}
```

Note that `Result` here can be a class or a structure.

## Named Captures

We can also use named captures.

Given an expression

```
(?xi)
(?<first>   \w+ ) ?(?-x: )
(?<number>  .*  ) ?(?-x: )
(?<last>    \w+ )
```

and a results structure:

```
class Result: NSObject {
    @objc var first = ""
    @objc var last = ""
    @objc var number = 0
}
```

We can match an expression and capture the results like this:

```
var result = Result()
if namedCapturePattern.firstMatch(in: "Sam 123 Deane", capturing: &result) {
    // result now contains the captured parameters
}
```

Note that the implementation relies on key-value support to write the results, so that `Result` instance 
has to be an Objective-C class, as do any named properties to be captured.

This is a limitation of Swift reflection, which currently only supports reading values.


