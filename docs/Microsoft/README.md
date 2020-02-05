# Federated Login with Microsoft

We need to start by registering an app in [Azure Active Directory admin center][1] as described in [this tutorial][2], creating a client ID and secret so Microsoft can identify us. Make sure to save the Client ID and Client secret.

Now that we have the necessary information for Microsoft, we will setup Imperial with our application.

Add the following line of code to your `dependencies` array in your package manifest file:

```swift
.package(url: "https://github.com/vapor-community/Imperial.git", from: "0.14.0")
```

**Note:** There might be a later version of the package available, in which case you will want to use that version.

You will also need to add the package as a dependency for the targets you will be using it in:

```swift
.target(name: "App", dependencies: ["Vapor", "Imperial"],
    exclude: [
        "Config",
        "Database",
        "Public",
        "Resources"
    ]
),
```

Then run `vapor update` or `swift package update`. Make sure you regenerate your Xcode project afterwards if you are using Xcode.

Now that Imperial is installed, we need to add `SessionMiddleware` to our middleware configuration:

```swift
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    //...

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
	// Other Middleware...
    middlewares.use(SessionsMiddleware.self)
    services.register(middlewares)
    
	//...
}

```

Now, when you run your app and you are using `FluentSQLite`, you will probably get the following error:

```
⚠️ [ServiceError.ambiguity: Please choose which KeyedCache you prefer, multiple are available: MemoryKeyedCache, FluentCache<SQLiteDatabase>.] [Suggested fixes: `config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)`. `config.prefer(FluentCache<SQLiteDatabase>.self, for: KeyedCache.self)`.]
```

Just pick one of the listed suggestions and place it at the top of your `configure` function. If you want your data to persist across server reboots, use `config.prefer(FluentCache<SQLiteDatabase>.self, for: KeyedCache.self)`

Imperial uses environment variables to access the client ID and secret to authenticate with Microsoft. To allow Imperial to access these tokens, you will create these variables, called `MICROSOFT_CLIENT_ID` and `MICROSOFT_CLIENT_SECRET`, with the client ID and secret assigned to them. Imperial can then access these vars and use there values to authenticate with Microsoft.

Now, all we need to do is register the Microsoft service in your main router method, like this:

```swift
try router.oAuth(from: Microsoft.self, authenticate: "microsoft", callback: "http://localhost:8080/microsoft-complete") { (request, token) in
    print(token)
    return Future(request.redirect(to: "/"))
}
```

If you just want to redirect, without doing anything else in the callback, you can use the helper `Route.oAuth` method that takes in a redirect string:

```swift
try router.oAuth(from: Microsoft.self, authenticate: "microsoft", callback: "http://localhost:8080/microsoft-complete", redirect: "/")
```

The `callback` argument is the path you will go to when you want to authenticate the user. The `callback` argument has to be the same path that you entered as `Redirect URI`when you registered your application on Microsoft Azure Active Directory admin center:

![The callback path for Microsoft OAuth](https://github.com/vapor-community/Imperial/blob/master/docs/Microsoft/callback-uri.png?raw=true)

The completion handler is fired when the callback route is called by the OAuth provider. The access token is passed in and a response is returned.

If you ever want to get the `access_token` in a route, you can use a helper method for the `Request` type that comes with Imperial:

```swift
let token = try request.accessToken()
```

Now that you are authenticating the user, you will want to protect certain routes to make sure the user is authenticated. You can do this by adding the `ImperialMiddleware` to a router group (or maybe your middleware config):

```swift
let protected = router.grouped(ImperialMiddleware())
```

Then, add your protected routes to the `protected` group:

```swift
protected.get("me", handler: me)
```

The `ImperialMiddleware` by default passes the errors it finds onto `ErrorMiddleware` where they are caught, but you can initialize it with a redirect path to go to if the user is not authenticated:

```swift
let protected = router.grouped(ImperialMiddleware(redirect: "/"))
```

[1]: https://aad.portal.azure.com/
[2]: https://docs.microsoft.com/en-us/graph/tutorials/php?tutorial-step=2
