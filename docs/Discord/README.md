# Federated Login with Discord

## Discord Setup

Start by going to the [Discord Developer Portal](https://discord.com/developers/applications), and creating an "New Application".
In the "OAuth2" tab click "Add Redirect" and fill in your callback URL.

## Imperial Integration

You can use Discord with the `ImperialDiscord` package. This expects two environment variables:

* `DISCORD_CLIENT_ID`
* `DISCORD_CLIENT_SECRET`

Additionally you must set `DiscordRouter.callbackURL` to an valid Redirect URL you added in the Developer Portal.

You can then register the OAuth provider like normal.

### References

Some potentially useful references:

* [Discord OAuth2 scopes](https://discord.com/developers/docs/topics/oauth2#shared-resources-oauth2-scopes)
