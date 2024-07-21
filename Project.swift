import ProjectDescription

let project = Project(
    name: "GolfApp",
    targets: [
        .target(
            name: "GolfApp",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.GolfApp",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["GolfApp/Sources/**"],
            resources: ["GolfApp/Resources/**"],
            dependencies: [
              .external(name: "SigmaSwiftStatistics"),
              .external(name: "FirebaseAuth"),
//              .external(name: "FirebaseCore"),
              .external(name: "FirebaseFirestore"),
              .external(name: "FirebaseFirestoreSwift"),
              .external(name: "FirebaseAuth"),
              
              
            ],
            settings: .settings(base: ["OTHER_LDFLAGS": "$(inherited) -ObjC"])
        ),
        .target(
            name: "GolfAppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.GolfAppTests",
            infoPlist: .default,
            sources: ["GolfApp/Tests/**"],
            resources: [],
            dependencies: [.target(name: "GolfApp")]
        ),
    ]
)
