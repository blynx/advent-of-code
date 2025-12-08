// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Day02_GiftShop",
	platforms: [
		.macOS(.v15)
	],
    targets: [
        .target(
            name: "Day02_GiftShop"
		),
		.testTarget(
			name: "Day02_GiftShopTests",
			dependencies: ["Day02_GiftShop"],
			resources: [
				.embedInCode("Resources/Input.txt"),
				.embedInCode("Resources/InputSmall.txt")
			]
		)
    ]
)
