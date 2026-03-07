// swift-tools-version: 6.2

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
            resources: [.process("Shaders")],
            swiftSettings: [
                .enableUpcomingFeature("InferIsolatedConformances"),
                .enableUpcomingFeature("NonisolatedNonsendingByDefault")
            ]
        ),
        .testTarget(
            name: "ColorblindsTests",
            dependencies: ["Colorblinds"],
            swiftSettings: [
                .enableUpcomingFeature("InferIsolatedConformances"),
                .enableUpcomingFeature("NonisolatedNonsendingByDefault")
            ]
        )
    ]
)
