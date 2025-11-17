// swift-tools-version:5.7
//
//  Package.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataUIObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "DNSDataUIObjects",
    platforms: [
        .iOS(.v16),
        .tvOS(.v16),
        .macCatalyst(.v16),
        .macOS(.v13),
        .watchOS(.v9),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DNSDataUIObjects",
            type: .static,
            targets: ["DNSDataUIObjects"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", .upToNextMajor(from: "4.3.0")),
        .package(url: "https://github.com/DoubleNode/DNSCore.git", .upToNextMajor(from: "1.12.1")),
        .package(url: "https://github.com/DoubleNode/DNSCoreThreading.git", .upToNextMajor(from: "1.12.1")),
        .package(url: "https://github.com/DoubleNode/DNSDataContracts.git", .upToNextMajor(from: "1.12.1")),
        .package(url: "https://github.com/DoubleNode/DNSDataObjects.git", .upToNextMajor(from: "1.12.2")),
        .package(url: "https://github.com/DoubleNode/DNSDataTypes.git", .upToNextMajor(from: "1.12.2")),
        .package(url: "https://github.com/DoubleNode/DNSError.git", .upToNextMajor(from: "1.12.0")),
        .package(url: "https://github.com/DoubleNode/DNSThemeTypes.git", .upToNextMajor(from: "1.12.1")),
//        .package(path: "../DNSCore"),
//        .package(path: "../DNSCoreThreading"),
//        .package(path: "../DNSDataContracts"),
//        .package(path: "../DNSDataObjects"),
//        .package(path: "../DNSDataTypes"),
//        .package(path: "../DNSError"),
//        .package(path: "../DNSThemeTypes"),
        .package(url: "https://github.com/kaishin/Gifu.git", .upToNextMajor(from: "4.0.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSDataUIObjects",
            dependencies: ["AlamofireImage", "DNSCore", "DNSCoreThreading",
                           "DNSDataContracts", "DNSDataObjects", "DNSDataTypes", "DNSError",
                           "DNSThemeTypes", "Gifu"]
        ),
        .testTarget(
            name: "DNSDataUIObjectsTests",
            dependencies: ["DNSDataUIObjects"]),
    ],
    swiftLanguageVersions: [.v5]
)
