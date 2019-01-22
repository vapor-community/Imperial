# Federated Login with Facebook

1. [Register with Facebook](#register-with-facebook)
2. [Add Imperial to Vapor App](#add-imperial-to-vapor-app)

## Register with Facebook
Start by going to the [Facebook Developer page](https://developers.facebook.com/), and sign-in/register. Then, go to the [Apps page](https://developers.facebook.com/apps/). Click 'Add a New App'. Enter an app Display Name and Contact Email and click Create App ID:

![Create the app](https://github.com/vapor-community/Imperial/blob/master/docs/Facebook/create-application.png)

Select Integrate Facebook Login and click the Confirm button. This will redirect to the Settings > Basic screen where you can find the App ID and App Secret. Before the app is live you'll need to fill out some of the other fields for privacy and GDPR disclosure. It will also add the Facebook Login Product in the left sidebar.

![App ID and App Secret](https://github.com/vapor-community/Imperial/blob/master/docs/Facebook/application-id.png)

In the left sidebar under Products, Click, Facebook Login > Settings. Enter one or more Valid OAuth Redirect URIs. Ex) https://fancyvapor.app/facebook/callback.

**Note:** Facebook requires HTTPS for redirect URIs so you'll need it on your development machine as well.

![Add Redirect URI](https://github.com/vapor-community/Imperial/blob/master/docs/Facebook/add-redirect-uri.png)

## Add Imperial to Vapor App
Now that the OAuth application registered with Facebook, we can add Imperial to our project. This tutorial will not cover how to create the project. It is assumed that step was already completed.

Add the following line of code to your `dependencies` array in your package manifest file:

```swift
.package(url: "https://github.com/vapor-community/Imperial.git", from: "0.8.0")
```

**Note:** There might be a later version of the package available, in which case you will want to use that version.

You will also need to add the package as a dependency for the targets you will be using it in:

```swift
.target(name: "App", dependencies: ["Vapor", "Imperial"],
               exclude: ["Config", "Database", "Public", "Resources"]),
```

Then run `vapor update` or `swift package update`. Make sure you regenerate your Xcode project (`vapor xcode`) if you are using Xcode.

Now that Imperial is installed, we need to add `middlewares.use(SessionsMiddleware.self)` to our middleware configuration in the `configure.swift` file:

```swift
import Imperial
//...

public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    //...

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // Other Middleware...
    middlewares.use(SessionsMiddleware.self) // Imperial session management
    services.register(middlewares)

    //...
}
```

If you Build (`vapor build`) and Run (`vapor run`) your app and you are using a database, you will probably get an error similar to below:

```
⚠️ [ServiceError.ambiguity: Please choose which KeyedCache you prefer, multiple are available: MemoryKeyedCache, FluentCache<SQLiteDatabase>.] [Suggested fixes: `config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)`. `config.prefer(FluentCache<SQLiteDatabase>.self, for: KeyedCache.self)`.]
```

Just pick one of the listed suggestions and place it at the top of your `configure` function. If you want your data to persist across server reboots, use `config.prefer(FluentCache<SQLiteDatabase>.self, for: KeyedCache.self)`

Imperial needs the client id and secret to authenticate with Facebook. To allow Imperial access to these tokens, you will need to set the environment variables, `FACEBOOK_CLIENT_ID` and `FACEBOOK_CLIENT_SECRET` from values found on the Facebook Settings page described above.

Now, all we need to do is register the GitHub service in your main router method, like this:

```swift
try router.oAuth(from: Facebook.self, authenticate: "facebook", callback: "https://fancyvapor.app/facebook/callback") { (request, token) in
    print(token)
    return request.future(request.redirect(to: "/"))
}
```

If you just want to redirect, without doing anything else in the callback, you can use the helper `Route.oAuth` method that takes in a redirect string:

```swift
import Imperial
//...

try router.oAuth(from: Facebook.self, authenticate: "facebook", callback: "https://fancyvapor.app/facebook/callback", redirect: "/")
```

The `authenticate` argument is the path you will go to when you want to authenticate the user. In the example above, `https://fancyvapor.app/facebook` would redirect the user to Facebook for authentication using the the required app id, secret, and redirect URI. Facebook will then validate the request and match the `callback` (redirect) URI to what was provided during registration.

Therefore, the `callback` argument needs to match one of the Valid OAuth Redirect URI entered in the Facebook app settings:

![The callback path for Facebook App](https://github.com/vapor-community/Imperial/blob/master/docs/GitHub/add-redirect-uri.png)

The completion handler is fired when the callback route is called by the OAuth provider. The access token is passed in and a response is returned.

The `access_token` is available within a route through an Imperial helper method for the `Request` type:

```swift
import Imperial
//...

let token = try request.accessToken()
```

Now that you are authenticating the user, you will want to protect certain routes to make sure the user is authenticated. You can do this by adding the `ImperialMiddleware` to a router group (or maybe your middleware config):

```swift
import Imperial
//...

let protected = router.grouped(ImperialMiddleware())
```

Then, add your protected routes to the `protected` group:

```swift
protected.get("me", handler: me)
```

The `ImperialMiddleware` by default passes the errors it finds onto `ErrorMiddleware` where they are caught, but you can initialize it with a redirect path to go to when the user is not authenticated:

```swift
import Imperial
//...

let protected = router.grouped(ImperialMiddleware(redirect: "/"))
```
