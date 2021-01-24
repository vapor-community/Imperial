# Federated Login with Shopify

## Shopify Setup

Create a Shopify Partner account by [registering here](https://www.shopify.ca/partners).

Create a new app by following [this guide](https://help.shopify.com/en/api/getting-started/authentication/public-authentication)

![](configure-app-creds.png)

This provides you with an OAuth Client ID and secret you can provide to Imperial.

The `callback` argument has to be the same path that you entered as a *Whitelisted redirection URL* on the app in the Partner Dashboard:

![](callback-uri.png)

## Imperial Integration

You can use GitHub with the `ImperialGitHub` package. This expects two environment variables:

* `SHOPIFY_CLIENT_ID`
* `SHOPIFY_CLIENT_SECRET`

You can then register the OAuth provider like normal.

You can make authenticated requests to the [REST API](https://help.shopify.com/en/api/reference) requests with a header X-Shopify-Access-Token: {access_token} where {access_token} is replaced with the access token.