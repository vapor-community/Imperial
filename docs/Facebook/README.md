# Federated Login with Facebook

1. [Register with Facebook](#register-with-facebook)
2. [Add Imperial to Vapor App](#add-imperial-to-vapor-app)
3. [Configuring Imperial](#configuring-imperial)
4. [Protecting Routes](#protecting-routes)

## Register with Facebook
Start by going to the [Facebook Developer page](https://developers.facebook.com/), and sign-in/register. Then, go to the [Apps page](https://developers.facebook.com/apps/). Click 'Add a New App'. Enter an app 'Display Name' and 'Contact Email', then click 'Create App ID':

![Create the app](https://github.com/vapor-community/Imperial/blob/master/docs/Facebook/create-application.png)

Select 'Integrate Facebook Login' and click the 'Confirm' button. This will redirect to the 'Settings > Basic' screen where you can find the generated 'App ID' and 'App Secret'. It will also add the 'Facebook Login' Product in the left sidebar. Before the app is live you will need to fill out some of the other fields for privacy and GDPR disclosure.

![App ID and App Secret](https://github.com/vapor-community/Imperial/blob/master/docs/Facebook/application-id.png)

In the left sidebar under Products, click 'Facebook Login > Settings'. Enter one or more 'Valid OAuth Redirect URIs'. Ex) https://fancyvapor.app/facebook/callback.

**Note:** Facebook requires https for redirect URIs so you'll need to use https in development and production environments. Setting up https is outside the scope of this tutorial.

![Add Redirect URI](https://github.com/vapor-community/Imperial/blob/master/docs/Facebook/add-redirect-uri.png)

## Add Imperial to Vapor App
Now that the application is registered with Facebook, we can add Imperial to our Vapor project. Creating and setting up a Vapor project is outside the scope of this tutorial.

Add the following line of code to your `dependencies` array in your package manifest file:

```swift
.package(url: "https://github.com/vapor-community/Imperial.git", from: "0.8.0")
```

**Note:** There might be a later version of the package available, in which case you will want to use that version.

Also, add the package as a dependency for the targets where it will be used:

```swift
.target(name: "App", dependencies: ["Vapor", "Imperial"],
               exclude: ["Config", "Database", "Public", "Resources"]),
```

Then run `vapor update` to fetch the Imperial package. Make sure to also regenerate your Xcode project (`vapor xcode`) if you are using Xcode.

Now that Imperial is installed, we need to add `middlewares.use(SessionsMiddleware.self)` to our middleware configuration in the `configure.swift` file. Remember to import the Imperial package as well.

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

Now, if you build and run (`vapor build && run`) your app and you are using a database, you may see a KeyedCache ambiguity error similar to below:

```
⚠️ [ServiceError.ambiguity: Please choose which KeyedCache you prefer, multiple are available: MemoryKeyedCache, FluentCache<SQLiteDatabase>.] [Suggested fixes: `config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)`. `config.prefer(FluentCache<SQLiteDatabase>.self, for: KeyedCache.self)`.]
```

Just pick one of the listed suggestions and place it at the top of your `configure` function. If you want your data to persist across server reboots, use `config.prefer(FluentCache<SQLiteDatabase>.self, for: KeyedCache.self)`


## Configuring Imperial

Imperial needs the client id and secret to authenticate with Facebook. To allow Imperial access to these tokens, you will need to set the environment variables, `FACEBOOK_CLIENT_ID` and `FACEBOOK_CLIENT_SECRET` using the respective values found on the Facebook settings page described above.

Now, all you need to do is register the Facebook authentication route in your main router method (for instance, in `configure.swift`):

```swift
try router.oAuth(from: Facebook.self, authenticate: "facebook", callback: "https://fancyvapor.app/facebook/callback") { (request, token) in
    print(token)
    return request.future(request.redirect(to: "/"))
}
```

The `authenticate` argument is the relative path you will go to when you want to authenticate with Facebook. Therefore, "facebook" would equal a full URL of `https://fancyvapor.app/facebook`. Visiting this URL will trigger Imperial to redirect to Facebook for authentication using the required parameters. Facebook will then validate the request and match the `callback` URI to the 'Valid OAuth Redirect URI' provided during registration.

Therefore, the `callback` argument needs to match one of the 'Valid OAuth Redirect URI' entered in the Facebook app settings:

![The callback path for Facebook App](https://github.com/vapor-community/Imperial/blob/master/docs/Facebook/add-redirect-uri.png)

**Note:** The callback URL should be an Environment variable in your application so it can change between environments. In development using a `.env` file and including this [`Environment+DotEnv.swift`](https://github.com/vapor-community/vapor-ext/blob/master/Sources/ServiceExt/Environment%2BDotEnv.swift) helper in your project makes it simple.

The completion handler is fired when the callback route is called by the OAuth provider (Facebook). The access token is passed in and a response is returned.

The `access_token` is available within a route through an Imperial helper method for the `Request` type:

```swift
import Imperial
//...

let token = try request.accessToken()
```

## Fetching User Data

With the accessToken your application can now access information about the user. The needs of each application differ so you can test out your implementation using [Facebook's Graph API Explorer](https://developers.facebook.com/tools/explorer/).

![Facebook's Graph API Explorer](https://github.com/vapor-community/Imperial/blob/master/docs/Facebook/facebook-graph-api-explorer.png)

When a user signs in with Facebook they will see what data your application is requesting and approve or reject the available data. The controller example below shows setting the route in your application which redirects the user to sign-in with Facebook, and the completion handler calls a `processFacebookLogin` function which will use the `accessToken` to fetch the user's data. It also will create a new user or sign-in existing users.

```swift
import Vapor
import Imperial
import Authentication

struct ImperialController: RouteCollection {
    func boot(router: Router) throws {
        guard let facebookCallbackURL = Environment.get("FACEBOOK_CALLBACK_URI") else {
            fatalError("Facebook callback URL not set")
        }
        try router.oAuth(from: Facebook.self, authenticate: "login-facebook", callback: facebookCallbackURL,
                         scope: [], completion: processFacebookLogin)
    }

    func processFacebookLogin(request: Request, token: String) throws -> Future<ResponseEncodable> {
        return try Facebook.getUserInfo(on: request).flatMap(to: ResponseEncodable.self) { userInfo in
            return User.query(on: request).filter(\.username == userInfo.id).first()
                                          .flatMap(to: ResponseEncodable.self) { foundUser in
                guard let existingUser = foundUser else {
                    return self.buildAndSaveNewUser(request: request, userInfo: userInfo)
                }
                return self.AuthenticateExistingUser(request: request, user: existingUser)
            }
        }
    }

    private func buildAndSaveNewUser(request: Request, userInfo: FacebookUserInfo) -> Future<ResponseEncodable> {
        let user = User(name: userInfo.name, username: userInfo.id, password: UUID().uuidString, email: userInfo.email)
        return user.save(on: request).map(to: ResponseEncodable.self) { user in
            try request.authenticateSession(user)
            return request.redirect(to: "users/\(user.id!)")
        }
    }

    private func AuthenticateExistingUser(request: Request, user: User) -> Future<ResponseEncodable> {
        return user.save(on: request).map(to: ResponseEncodable.self) { user in
            try request.authenticateSession(user)
            return request.redirect(to: "users/\(user.id!)")
        }
    }
}
```

We also need to extend the Facebook class to add the `getUserInfo` function. Customizing the last part of the `facebookUserAPIURL` will allow you to access the user data needed by your application. Refer to the Graph Explorer for testing what attributes are available. For convenience we decode the response using a small struct called `FacebookUserInfo`.

```swift
struct FacebookUserInfo: Content {
    let id: String
    let email: String
    let name: String
}

extension Facebook {
    static func getUserInfo(on request: Request) throws -> Future<FacebookUserInfo> {
        let token = try request.accessToken()
        let facebookUserAPIURL = "https://graph.facebook.com/v3.2/me?fields=id,name,email&access_token=\(token)"
        return try request.client().get(facebookUserAPIURL).map(to: FacebookUserInfo.self) { response in
            guard response.http.status == .ok else {
                if response.http.status == .unauthorized {
                    throw Abort.redirect(to: "/login-facebook")
                } else {
                    throw Abort(.internalServerError)
                }
            }
            return try response.content.syncDecode(FacebookUserInfo.self)
        }
    }
}
```

## Protecting Routes

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
