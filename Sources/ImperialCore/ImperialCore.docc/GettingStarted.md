# Getting Started with Imperial

Federated Authentication with OAuth providers for Vapor.

## Overview

Imperial is a Federated Login service, allowing you to easily integrate your Vapor applications with OAuth providers to handle your apps authentication.

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

If you just want to redirect, without doing anything else in the callback, you can use the helper `oAuth(from:authenticate:authenticateCallback:callback:scope:redirect:)` method that takes in a redirect string:

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
