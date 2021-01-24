# Federated Login with Imgur

Start by going to the [Imgur App registration page](https://api.imgur.com/oauth2/addclient). Select the authorization type "OAuth 2 authorization with a callback URL". Fill in the rest of the app information, particularly the Authorization callback URL:

![Redirect URI](callback-url.png)

Note that, as opposed to most other services, Imgur allows only one callback URL per app — if you would like multiple URLs (e.g. for test and production), you'll have to register multiple apps. 

This provides you with an OAuth Client ID and secret you can provide to Imperial.

## Imperial Integration

You can use Imgur with the `ImperialImgur` package. This expects two environment variables:

* `IMGUR_CLIENT_ID`
* `IMGUR_CLIENT_SECRET`

You can then register the OAuth provider like normal.
