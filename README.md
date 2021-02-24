#  Simple GRPC Client (Swift)

This swift client was made for [this project](https://github.com/thesepehrm/simple-grpc).

## How to rebuild this project

First of all, you need to install `protoc` using homebrew:
```bash
brew install swift-protobuf
```
Also you may need to install `protoc-gen-grpc-swift` and `protoc-gen-swift` plugins on your mac. [Binaries](https://github.com/grpc/grpc-swift/releases/download/1.0.0/protoc-grpc-swift-plugins-1.0.0.zip)

Now make an xcode project and add gRPC swift as a dependency:

The Swift Package Manager is the preferred way to get gRPC Swift. Simply add the
package dependency to your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.0.0")
]
```

Use the [makefile](./Makefile) in this project to generate pb and grpc.pb files. Remember to correct its variables for your own project. Then link the generated files to your xcode project.

Just edit the endpoint to the test API address in [main.swift](./simple-grpc-swift/main.swift) and *voilà*! 









