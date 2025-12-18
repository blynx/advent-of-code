// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Day04_PrintingDepartment",
	platforms: [
		.macOS(.v13)
	],
	dependencies: [
	    .package(path: "../../lib/Swift/SwiftGrid")
	],
    targets: [
        .target(
            name: "Day04_PrintingDepartment",
            dependencies: ["SwiftGrid"]
		),
		.testTarget(
			name: "Day04_PrintingDepartmentTests",
			dependencies: ["Day04_PrintingDepartment", "SwiftGrid"],
			resources: [
				.embedInCode("Resources/Input.txt")
			]
		)
    ]
)
