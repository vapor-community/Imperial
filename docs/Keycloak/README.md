# Federated Login with Keycloak

## Keycloak Setup

> The implementation may vary depending on your configuration

It's your first time with Keycloak? Check the [Started Guide][1].

- In your Keycloak realm, go to **Clients** and select or create a new client.
- Inside your client, go to **Credentials** and get the **Secret**.

This provides you with an OAuth Client ID and secret you can provide to Imperial.

## Imperial Integration

You can use GitHub with the `ImperialGitHub` package. This expects four environment variables:

* `KEYCLOAK_CLIENT_ID`
* `KEYCLOAK_CLIENT_SECRET`
* `KEYCLOAK_ACCESS_TOKEN_URL`
* `KEYCLOAK_AUTH_URL`

In many case, `KEYCLOAK_ACCESS_TOKEN_URL` have the current patern `http://localhost:8080/auth/realms/{realmName]/protocol/openid-connect/token` (but may vary if you use a proxy). And `KEYCLOAK_AUTH_URL` is generally `http://localhost:8080/auth/realms/{realmName}/protocol/openid-connect`.

You can then register the OAuth provider like normal.

[1]: https://www.keycloak.org/docs/latest/getting_started/index.html
