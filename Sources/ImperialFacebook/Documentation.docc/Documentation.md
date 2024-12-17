# ``ImperialFacebook``

Federated Authentication with Facebook for Vapor.

## Overview

### Register with Facebook

Start by going to the [Facebook Developer page](https://developers.facebook.com/), and sign-in/register.
Then, go to the [Apps page](https://developers.facebook.com/apps/).
Click `Add a New App`. Enter an app `Display Name` and `Contact Email`, then click `Create App ID`:

![Create the app](create-application)

Select `Integrate Facebook Login` and click the `Confirm` button.
This will redirect to the `Settings > Basic` screen where you can find the generated `App ID` and `App Secret`.
It will also add the `Facebook Login` Product in the left sidebar.
Before the app is live you will need to fill out some of the other fields for privacy and GDPR disclosure.

![App ID and App Secret](application-id)

In the left sidebar under Products, click `Facebook Login > Settings`.
Enter one or more `Valid OAuth Redirect URIs`.
For example: `https://fancyvapor.app/facebook/callback`.

> Note: Facebook requires `https` for redirect URIs so you'll need to use `https` in development and production environments. Setting up `https` is outside the scope of this tutorial.

![Add Redirect URI](add-redirect-uri)

This provides you with an OAuth Client ID and secret you can provide to Imperial.

### Imperial Integration

You can use Facebook with the `ImperialFacebook` package. This expects two environment variables:

* `FACEBOOK_CLIENT_ID`
* `FACEBOOK_CLIENT_SECRET`

You can then register the OAuth provider like normal.

### Fetching User Data

With the `accessToken` your application can now access information about the user.
The needs of each application differ so you can test out your implementation using [Facebook's Graph API Explorer](https://developers.facebook.com/tools/explorer/).

![Facebook's Graph API Explorer](facebook-graph-api-explorer)

You can extend ``Facebook`` to add a `getUserInfo` function to get the user details.
Customizing the last part of the `facebookUserAPIURL` will allow you to access the user data needed by your application.
Refer to the Graph Explorer for testing what attributes are available.
For convenience we decode the response using a small struct called `FacebookUserInfo`.

```swift
struct FacebookUserInfo: Content {
    let id: String
    let email: String
    let name: String
}

extension Facebook {
    static func getUserInfo(on request: Request) async throws -> FacebookUserInfo {
        let token = try request.accessToken
        let facebookUserAPIURL: URI = "https://graph.facebook.com/v3.2/me?fields=id,name,email&access_token=\(token)"

        let response = try await request.client.get(facebookUserAPIURL)
        guard response.status == .ok else {
            if response.status == .unauthorized {
                throw Abort.redirect(to: "/login-facebook")
            } else {
                throw Abort(.internalServerError)
            }
        }
        return try response.content.decode(FacebookUserInfo.self)
    }
}
```
