# Imperial Docs

## Adding Imperial as a dependency

Imperial is made up of `ImperialCore`, which contains the main logic for the library and a number of provider packages. Normally, you'll only integrate the provider package. First, add the following line of code to your `dependencies` array in your package manifest file:

```swift
.package(url: "https://github.com/vapor-community/Imperial.git", from: "1.0.0")
```

Next add the package for the provider you want to use to your target's dependencies array. For example, to add GitHub:

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Vapor", package: "vapor"),
        .product(name: "ImperialGitHub", package: "Imperial")
        // ...
    ],
    // ...
```

## Sessions Middleware

Imperial relies on the [sessions middleware](https://docs.vapor.codes/4.0/sessions/#configuration) to save state and access tokens. In **configure.swift**, or as a route group for specific routes, add the sessions middleware. For example, to add it globally:

```swift
app.middleware.use(app.sessions.middleware)
```

## Route Registration

Imperial uses environment variables to access the client ID and secret to authenticate with the provider. See the provider specific docs for details on what they should be.

You need to register the OAuth service with your route. For example, to register a GitHub integration add the following:

```swift
try routes.oAuth(from: GitHub.self, authenticate: "github", callback: "gh-auth-complete") { (request, token) in
    print(token)
    return request.eventLoop.future(request.redirect(to: "/"))
}
```

This registers a route to `/github`. When you visit that route, Imperial will trigger the OAuth flow using the `GitHub` service. The callback path is the one registered with the OAuth provider when you create your application. The completion handler is fired when the callback route is called by the OAuth provider. The access token is passed in and a response is returned.

If you just want to redirect, without doing anything else in the callback, you can use the helper `RoutesBuilder.oAuth(from:authenticate:authenticateCallback:callback:scope:redirect:)` method that takes in a redirect string:

```swift
try router.oAuth(from: GitHub.self, authenticate: "github", callback: "gh-auth-complete", redirect: "/")
```

## Access Tokens and Middleware

If you ever want to get the `access_token` in a route, you can use a helper method for the `Request` type that comes with Imperial:

```swift
let token = try request.accessToken()
```

Now that you are authenticating the user, you will want to protect certain routes to make sure the user is authenticated. You can do this by adding the `ImperialMiddleware` to a router group (or maybe your middleware config):

```swift
let protected = routes.grouped(ImperialMiddleware())
```

Then, add your protected routes to the `protected` group:

```swift
protected.get("me", use: me)
```

The `ImperialMiddleware` by default passes the errors it finds onto `ErrorMiddleware` where they are caught, but you can initialize it with a redirect path to go to if the user is not authenticated:

```swift
let protected = routes.grouped(ImperialMiddleware(redirect: "/"))
```

## Provider Specific Docs

Below are links to the documentation to setup federated login with various OAuth providers that are supported.

- [GitHub](https://github.com/vapor-community/Imperial/blob/main/docs/GitHub/README.md)
- [Google](https://github.com/vapor-community/Imperial/blob/main/docs/Google/README.md)
- [Shopify](https://github.com/vapor-community/Imperial/blob/main/docs/Shopify/README.md)
- [Facebook](https://github.com/vapor-community/Imperial/tree/main/docs/Facebook/README.md)
- [Keycloak](https://github.com/vapor-community/Imperial/tree/main/docs/Keycloak/README.md)
- [Discord](https://github.com/vapor-community/Imperial/tree/main/docs/Discord/README.md)
- [Auth0](https://github.com/vapor-community/Imperial/tree/main/docs/Auth0/README.md)
