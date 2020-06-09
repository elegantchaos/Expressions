// swift-tools-version:5.0

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 09/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import PackageDescription

let package = Package(
    name: "Expressions",
    platforms: [
        .macOS(.v10_13), .iOS(.v12), .tvOS(.v11)
    ],
    products: [
        .library(
            name: "Expressions",
            targets: ["Expressions"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Expressions",
            dependencies: []),
        .testTarget(
            name: "ExpressionsTests",
            dependencies: ["Expressions"]),
    ]
)
