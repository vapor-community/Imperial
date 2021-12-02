# Federated Login with Microsoft

## Microsoft Setup

We need to start by registering an app in [Azure Active Directory admin center][1] as described in [this tutorial][2], creating a client ID and secret so Microsoft can identify us. Make sure to save the Client ID and Client secret.

This provides you with an OAuth Client ID and secret you can provide to Imperial.

## Imperial Integration

You can use Microsoft with the `ImperialMicrosoft` package. This expects two environment variables:

* `MICROSOFT_CLIENT_ID`
* `MICROSOFT_CLIENT_SECRET`

You can then register the OAuth provider like normal.

[1]: https://aad.portal.azure.com/
[2]: https://docs.microsoft.com/en-us/graph/tutorials/php?tutorial-step=2
