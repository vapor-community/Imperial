# ``ImperialDeviantArt``

Federated Authentication with DeviantArt for Vapor.

## Overview

### DeviantArt Setup

Start by going to the [DeviantArt developers page](https://www.deviantart.com/developers/).
Click the `Register your Application` button.

![Create the app](create-application)

Fill in the app information, particularly the OAuth2 Redirect URI Whitelist:

![Redirect URI](callback-url)

This provides you with an OAuth Client ID and secret you can provide to Imperial.

### Imperial Integration

You can use DeviantArt with the `ImperialDeviantArt` package. This expects two environment variables:

* `DEVIANTART_CLIENT_ID`
* `DEVIANTART_CLIENT_SECRET`

You can then register the OAuth provider like normal.
