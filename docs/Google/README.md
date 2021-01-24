# Federated Login with Google

We need to start by creating a client ID and secret so Google can identify us. Go to the [Credentials tab][1] of the Google Developer's Console on the API page.

Select 'Create credentials' > 'OAuth client ID':

![Create Credentials](https://github.com/vapor-community/Imperial/blob/master/docs/Google/create-oauth-credentials.png?raw=true)

Select 'Web application'. The name that you enter should be the name of your project. Under the 'Restrictions' section, in 'Authorized redirect URIs', you will need to add a URI for Google to redirect to after the authentication is complete. If you are developing locally, it will be `http://localhost:8080/...` or `https...` if you have configured SSL:

![Create Credentials](https://github.com/vapor-community/Imperial/blob/master/docs/Google/configure-app-creds.png?raw=true)

This provides you with an OAuth Client ID and secret you can provide to Imperial.

## Imperial Integration

You can use GitHub with the `ImperialGitHub` package. This expects two environment variables:

* `GOOGLE_CLIENT_ID`
* `GOOGLE_CLIENT_SECRET`

You can then register the OAuth provider like normal.

[1]: https://console.developers.google.com/apis/credentials
