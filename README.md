<div align="center">
    <img src="https://avatars.githubusercontent.com/u/26165732?s=200&v=4" width="100" height="100" alt="avatar" />
    <h1>Imperial</h1>
    <a href="https://swiftpackageindex.com/vapor-community/Imperial/documentation">
        <img src="https://design.vapor.codes/images/readthedocs.svg" alt="Documentation">
    </a>
    <a href="https://discord.gg/vapor"><img src="https://design.vapor.codes/images/discordchat.svg" alt="Team Chat"></a>
    <a href="LICENSE"><img src="https://design.vapor.codes/images/mitlicense.svg" alt="MIT License"></a>
    <a href="https://github.com/vapor-community/Imperial/actions/workflows/test.yml">
        <img src="https://img.shields.io/github/actions/workflow/status/vapor-community/Imperial/test.yml?event=push&style=plastic&logo=github&label=tests&logoColor=%23ccc" alt="Continuous Integration">
    </a>
    <a href="https://codecov.io/github/vapor-community/Imperial">
        <img src="https://img.shields.io/codecov/c/github/vapor-community/Imperial?style=plastic&logo=codecov&label=codecov">
    </a>
    <a href="https://swift.org">
        <img src="https://design.vapor.codes/images/swift60up.svg" alt="Swift 6.0+">
    </a>
</div>
<br>

🔐 Federated Authentication with OAuth providers for Vapor.

### Installation

Use the SPM string to easily include the dependendency in your `Package.swift` file

```swift
.package(url: "https://github.com/vapor-community/Imperial.git", from: "2.0.0-beta.1")
```

and then add the desired provider to your target's dependencies:

```swift
.product(name: "ImperialGoogle", package: "imperial")
```

## Overview

Imperial is a Federated Login service, allowing you to easily integrate your Vapor applications with OAuth providers to handle your apps authentication.
