# Federated Login with netID

[netID](https://netid.de) is a federated european login service following the OIDC standard.

To start go to https://developer.netid.de and create a service and a client for your project. For testing purposes you'll need to add at least one test user to the service. 
Remember the Client ID and the Client secret created for your client.

For integrating Imperial into your Vapor project follow the correspondent section in [Federated Login with Google](../Google/README.md).

Imperial uses environment variables to access the client ID and secret to authenticate with netID. To allow Imperial to access these tokens, you will create these variables, called `NETID_CLIENT_ID` and `NETID_CLIENT_SECRET`, with the client ID and secret assigned to them. Imperial can then access these vars and use there values to authenticate with netID.

Now, all you need to do is register the netID service in your main router method, like this:

```swift
let config = NetIDConfig(
    authenticate: "netid/authenticate",
    callback: "\(siteURL)/netid/authenticate-callback",
    claims: ["given_name", "family_name", "email"],
    state: { request in
        guard let state = try create_state(on: request) else {
            throw Abort(.internalServerError)
        }
        return state
    }
)
try Imperial.NetID(router: router, config: config) { request, token in
    // check state in request parameters if used
    guard state_from_request == state_created_before else {
         throw Abort(.forbidden)
    }

    print(token)

    return Future(request.redirect(to: "/"))
}
```

The `callback` argument is the URL you will go to when you want to authenticate the user. The `callback` argument has to be the same URL that you entered when you registered your client on netID.

Using `claims` you can specify which information from the end user you want to retrieve from the userinfo endpoint.

The optional `state` closure can be used to add a state parameter to the authorization request (see [State Parameter](https://auth0.com/docs/protocols/oauth2/oauth-state)). This parameter is returned on the `callback` uri and will be available on the request object given to the completion closure. If you want to use a state the `state` closure should return a string containing a unique and non-guessable value associated with each authentication. You MUST validate the state parameter in the completion handler.

The completion handler is fired when the callback route is called by the login provider. The callback request object and the access token is passed in and a response is returned.

