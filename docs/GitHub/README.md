# Federated Login with GitHub

Start by going to the [GitHub Developer Program page](https://developer.github.com/program/), and register. Then, go to your Account Settings, then the [Developer Settings](https://github.com/settings/developers). Select 'New OAuth App'. Fill out the information required and register the application:

![Create the app](https://github.com/vapor-community/Imperial/blob/master/docs/GitHub/create-application.png)

Now that we have an OAuth application registered with GitHub, we can add Imperial to our project (We will not be going over how to create the project, as I will assume that you have already done that).

Imperial uses environment variables to access the client ID and secret to authenticate with GitHub. To allow Imperial to access these tokens, you will create these variables, called `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET`, with the client ID and secret assigned to them. Imperial can then access these vars and use their values to authenticate with GitHub.

Now, all we need to do is register the GitHub service in your main router method, like this:

```swift
try router.oAuth(from: GitHub.self, authenticate: "github", callback: "gh-auth-complete") { (request, token) in
    print(token)
    return Future(request.redirect(to: "/"))
}
```

If you just want to redirect, without doing anything else in the callback, you can use the helper `Route.oAuth` method that takes in a redirect string:

```swift
try router.oAuth(from: GitHub.self, authenticate: "github", callback: "gh-auth-complete", redirect: "/")
```

The `authenticate` argument is the path you will go to when you want to authenticate the user. The `callback` argument has to be the same path that you entered when you registered your application on GitHub:

![The callback path for GitHub OAuth](https://github.com/vapor-community/Imperial/blob/master/docs/GitHub/callback-url.png)

The completion handler is fired when the callback route is called by the OAuth provider. The access token is passed in and a response is returned.
