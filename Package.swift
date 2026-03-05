// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Colorblinds",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Colorblinds",
            targets: ["Colorblinds"]
        )
    ],
    targets: [
        .target(
            name: "Colorblinds",
            resources: [.process("Shaders")]
        ),
        .testTarget(
            name: "ColorblindsTests",
            dependencies: ["Colorblinds"]
        )
    ]
)
