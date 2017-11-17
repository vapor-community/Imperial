# Federated Login with Google

We need to start by creating a client ID and secret so Google can identify us. Go to the [Credentials tab][1] of the Google Developer's Console on the API page.

Select 'Create credentials' > 'OAuth client ID':

![Create Credentials](https://github.com/vapor-community/Imperial/blob/master/docs/Google/create-oauth-credentials.png)

Select 'Web application'. The name that you enter should be the name of your project. Under the 'Restrictions' section, in 'Authorized redirect URIs', you will need to add a URI for Google to redirect to after the authentication is complete. If you are developing locally, it will be `http://localhost:8080/...` or `https...` if you have configured SSL:

![Create Credentials](https://github.com/vapor-community/Imperial/blob/master/docs/Google/configure-app-creds.png)

Now that we have the necessary information for Google, we will setup Imperial with our application.

Add the following line of code to your `dependencies` array in your package manifest file:

```swift
.package(url: "https://github.com/vapor-community/Imperial.git", .upToNextMajor(from: "0.3.0"))
```

**Note:** There might be a later version of the package available, in which case you will want to use that version.

You will also need to add the package as a dependency for the targets you will be using it in:

```swift
.target(name: "App", dependencies: ["Vapor", "LeafProvider", "Imperial"],
               exclude: [
                   "Config",
                   "Database",
                   "Public",
                   "Resources"
               ]),
```

Then run `vapor update` or `swift package update`. Make sure you regenerate your Xcode project afterwards if you are using Xcode.

Now we need to make the client ID and secret available to Imperial. WE can do this by creating environment variables, and, if you want, add the vars to your config.

Create two environment variables, `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` with the ID and secret that you generated in the first steps of this guide.

If you want, you can add the variables to your configuration. To do this, create a `secrets` directory in you `Config` folder if you haven't already, then create a file `imperial.json`. Then, add the following to the file:

```json
{
	"google_client_id": "$GOOGLE_CLIENT_ID",
	"google_client_secret": "$GOOGLE_CLIENT_SECRET"
}
```


While we are still looking at JSON, go to the `droplet.json` file and add `"sessions"` to the `middleware` array:

```json
"middleware": [
        "error",
        "date",
        "file",
        "sessions"
    ], ...
```

Now that the ID and secret are available to Imperial, we can initialize the Google authentication in the project.

Imperial's provider needs to be added to the droplet's `config`. Import Imperial into you `Config+Setup.swift` file, then add the provider in the `setupProviders` method:

```swift
/// Configure providers
private func setupProviders() throws {
	// Other providers that where already added are here.
    try addProvider(Imperial.Provider.self)
}
```

<!-- Break -->

Now, all we need to do is create and instance of Google with the authentication paths. In your `Droplet+Setup.swift` file, create an instance of `Google` in the `setup` method:

```swift
try Google(authenticate: "authenticate", callback: "http://localhost:8080/google-complete") { token in
    print(token)
    return Response(redirect: "/")
}
```

The `authenticate` argument is the path you will go to when you want to authenticate the user. The `callback` argument has to be the same URI that you entered when you registered your application on Google:

![The callback URI for Google OAuth](https://github.com/vapor-community/Imperial/blob/master/docs/Google/callback-uri.png)

The completion handler is fired when the callback route is called by Google. The access token is passed in and a response is returned. Typically you will want a redirecting response that sends the user back to your application after they have authenticated.

There is another parameter available to the `Google.init` method, called `scope`. The scope parameter takes in a dictionary of type `[String: String]`. The key can be left empty, it is not used, but the values are populated with the scopes that you want to be able to access from the Google API. A full list of the available scopes can be found [here](https://developers.google.com/identity/protocols/googlescopes)

If you ever want to get the `access_token` in a route, you can use a helper method for the `Request` type that comes with Imperial:

```swift
let token = try request.getAccessToken()
```

Now that you are authenticating the user, you will want to protect certain routes to make sure the user is authenticated. You can do this by adding the `ImperialMiddleware` to a droplet group:

```swift
let protected = drop.grouped(ImperialMiddleware())
```

Then, add your protected routes to the `protected` group:

```swift
protected.get("me", handler: me)
```

The `ImperialMiddleware` by default passes the errors it finds onto `ErrorMiddleware` where they are caught, but you can initialize it with a redirect path to go to if the user is not authenticated:

```swift
let protected = drop.grouped(ImperialMiddleware(redirect: "/"))
```


[1]: https://console.developers.google.com/apis/credentials