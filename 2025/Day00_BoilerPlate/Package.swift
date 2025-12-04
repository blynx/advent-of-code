// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Day00_BoilerPlate",
    targets: [
        .target(
            name: "Day00_BoilerPlate"
		),
		.testTarget(
			name: "Day00_BoilerPlateTests",
			dependencies: ["Day00_BoilerPlate"],
			resources: [
				.embedInCode("Resources/Input.txt"),
				.embedInCode("Resources/InputSmall.txt")
			]
		)
    ]
)
