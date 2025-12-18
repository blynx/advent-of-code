// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Day05_Cafeteria",
    platforms: [.macOS(.v13)],
    targets: [
        .target(
            name: "Day05_Cafeteria"
		),
		.testTarget(
			name: "Day05_CafeteriaTests",
			dependencies: ["Day05_Cafeteria"],
			resources: [
				.embedInCode("Resources/Input.txt")
			]
		)
    ]
)
