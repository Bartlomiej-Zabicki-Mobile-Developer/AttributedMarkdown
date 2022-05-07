// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AttributedMarkdown",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AttributedMarkdown",
            targets: ["AttributedMarkdown"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-markdown.git", .branch("main")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AttributedMarkdown",
            dependencies: [.productItem(name: "Markdown", package: "swift-markdown", condition: .none)]),
    ]
)
