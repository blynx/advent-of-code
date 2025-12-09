// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Day03_Lobby",
    targets: [
        .target(
            name: "Day03_Lobby"
		),
		.testTarget(
			name: "Day03_LobbyTests",
			dependencies: ["Day03_Lobby"],
			resources: [
				.embedInCode("Resources/Input.txt")
			]
		)
    ]
)
