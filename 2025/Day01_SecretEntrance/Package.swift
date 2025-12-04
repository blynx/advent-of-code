// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Day01_SecretEntrance",
    targets: [
        .target(
            name: "Day01_SecretEntrance"
		),
		.testTarget(
			name: "Day01_SecretEntranceTests",
			dependencies: ["Day01_SecretEntrance"],
			resources: [
				.embedInCode("Resources/Input.txt"),
				.embedInCode("Resources/InputSmall.txt")
			]
		)
    ]
)
