# Federated Login with GitHub

Start by going to the [GitHub Developer Program page](https://developer.github.com/program/), and register. Then, go to your Account Settings, then the [Developer Settings](https://github.com/settings/developers). Select 'New OAuth App'. Fill out the information required and register the application:

![Create the app](https://github.com/vapor-community/Imperial/blob/master/docs/GitHub/create-application.png)

Now that we have an OAuth application registered with GitHub, we can add Imperial to our project (We will not be going over how to create the project, as I will assume that you have already done that).

Add the following line of code to your `dependencies` array in your package manifest file:

```swift
.package(url: "https://github.com/vapor-community/Imperial.git", .upToNextMajor(from: "0.1.0"))
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

Now that Imperial is installed, we need to add the provider to the droplet's config. Import Imperial into you `Config+Setup.swift` file, then add the provider in the `setupProviders` method:

```swift
/// Configure providers
private func setupProviders() throws {
	// Other providers that where already added are here.
    try addProvider(Imperial.Provider.self)
}

```

Imperial uses either environment variables or configuration values to access the client ID and secret to authenticate with GitHub. There are three options to configure the vars so Imperial can access them.

1: Create two environment variables, called `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET`, with the client ID and secret assigned to them. Imperial can then access these vars and use there values to authenticate with GitHub.

The other two options require you to do the following:

Create a `secrets` directory in you `Config` directory if you haven't already, then create an `imperial.json` file, then you can either:

2: Added the ID and secret directly:

```json
{
    "github_client_id": "<YOUR_ID_HERE>",
    "github_client_secret": "<YOUR_SECRET_HERE>"
}
```

Or 3: Create the environment variables like the instructions in point 1 say, then add the following to your `imperial.json`:

```json
{
    "github_client_id": "$GITHUB_CLIENT_ID",
    "github_client_secret": "$GITHUB_CLIENT_SECRET"
}
```

Now, all we need to do is create and instance of GitHub with the authentication paths. In your `Droplet+Setup.swift` file, create an instance of `GitHub` in the `setup` method:

```swift
try GitHub(authenticate: "authenticate", callback: "gh-auth") { token in
    print(token)
    return Response(redirect: "/")
}
```

The `authenticate` argument is the path you will go to when you want to authenticate the user. The `callback` argument has to be the same path that you entered when you registered your application on GitHub:

![The callback path for GitHub OAuth](https://github.com/vapor-community/Imperial/blob/master/docs/GitHub/callback-url.png)

The completion handler is fired when the callback route is called by GitHub. The access token is passed in and a response is returned. Typically you will want a redirecting response that sends the user back to your application after they have authenticated.

Now that you are authenticating the user, you will want to protect certain routes to make sure the user is authenticated. You can do this by adding the `ImperialMiddleware` to a droplet group:

```swift
let protected = drop.grouped(ImperialMiddleware)
```