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
let protected = route.grouped(ImperialMiddleware(redirect: "/"))
```

## Provider Specific Docs

Below are links to the documentation to setup federated login with various OAuth providers that are supported.

- [GitHub](https://github.com/vapor-community/Imperial/blob/master/docs/GitHub/README.md)
- [Google](https://github.com/vapor-community/Imperial/blob/master/docs/Google/README.md)
- [Shopify](https://github.com/vapor-community/Imperial/blob/master/docs/Shopify/README.md)
- [Facebook](https://github.com/vapor-community/Imperial/tree/master/docs/Facebook/README.md)
- [Keycloak](https://github.com/vapor-community/Imperial/tree/master/docs/Keycloak/README.md)