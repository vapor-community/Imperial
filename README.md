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
.package(url: "https://github.com/vapor-community/Imperial.git", from: "2.0.0-beta.2")
```

and then add the desired provider to your target's dependencies:

```swift
.product(name: "ImperialGitHub", package: "imperial")
```

## Overview

Imperial is a Federated Login service, allowing you to easily integrate your Vapor applications with OAuth providers to handle your apps authentication.

## Getting Started

### Sessions Middleware

Imperial relies on the [sessions middleware](https://docs.vapor.codes/4.0/sessions/#configuration) to save state and access tokens. In **configure.swift**, or as a route group for specific routes, add the sessions middleware. For example, to add it globally:

```swift
app.middleware.use(app.sessions.middleware)
```

### Route Registration

Imperial uses environment variables to access the client ID and secret to authenticate with the provider. See the provider specific docs for details on what they should be.

You need to register the OAuth service with your route. For example, to register a GitHub integration add the following:

```swift
try routes.oAuth(from: GitHub.self, authenticate: "github", callback: "gh-auth-complete") { req, token in
    print(token)
    return req.redirect(to: "/")
}
```

This registers a route to `/github`. When you visit that route, Imperial will trigger the OAuth flow using the `GitHub` service. The callback path is the one registered with the OAuth provider when you create your application. The completion handler is fired when the callback route is called by the OAuth provider. The access token is passed in and a response is returned.

If you just want to redirect, without doing anything else in the callback, you can use the helper ``RoutesBuilder/oAuth(from:authenticate:authenticateCallback:callback:scope:redirect:)`` method that takes in a redirect string:

```swift
try router.oAuth(from: GitHub.self, authenticate: "github", callback: "gh-auth-complete", redirect: "/")
```

### Access Tokens and Middleware

If you ever want to get the `access_token` in a route, you can use a helper method for the `Request` type that comes with Imperial:

```swift
let token = try request.accessToken
```

Now that you are authenticating the user, you will want to protect certain routes to make sure the user is authenticated. You can do this by adding the ``ImperialMiddleware`` to a router group (or maybe your middleware config):

```swift
let protected = routes.grouped(ImperialMiddleware())
```

Then, add your protected routes to the `protected` group:

```swift
protected.get("me", use: me)
```

The ``ImperialMiddleware`` by default passes the errors it finds onto `ErrorMiddleware` where they are caught, but you can initialize it with a redirect path to go to if the user is not authenticated:

```swift
let protected = routes.grouped(ImperialMiddleware(redirect: "/"))
```
