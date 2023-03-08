// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.


//
//  Package.swift
//  SubrosaKit
//  Created by Dimka Novikov on 08.03.2023.
//  Copyright © 2023 Exhausted Reality. All rights reserved.
//


// MARK: Import section

import PackageDescription



// MARK: - SubrosaKit Swift Package

let package = Package(
    name: "SubrosaKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Subrosa Confidential",
            targets: [
                "SubrosaKit"
            ]
        )
    ],
    targets: [
        .binaryTarget(
            name: "SubrosaKit",
            path: "./XCFramework/SubrosaKit.xcframework"
        )
    ],
    swiftLanguageVersions: [
        .v5
    ],
    cLanguageStandard: .c18,
    cxxLanguageStandard: .cxx20
)
