// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
        productTypes: [
          :
//          "FLPPromises": .framework
        ]
    )
#endif

let package = Package(
    name: "GolfApp",
    dependencies: [
        // Add your own dependencies here:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
      .package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: "10.23.1"),
      .package(url: "https://github.com/evgenyneu/SigmaSwiftStatistics", .upToNextMajor(from: "9.0.0"))
    
    ]
)
