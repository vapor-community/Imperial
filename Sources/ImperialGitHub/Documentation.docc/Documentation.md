# ``ImperialGitHub``

Federated Authentication with GitHub for Vapor.

## Overview

### GitHub Setup

Start by going to the [GitHub Developer Program page](https://developer.github.com/program/), and register.
Then, go to your Account Settings, then the [Developer Settings](https://github.com/settings/developers).
Select `New OAuth App`.
Fill out the information required and register the application:

![Create the app](create-application)

You must also specify a callback URL.
Imperial will register a route to this URL to handle the redirect for you:

![The callback path for GitHub OAuth](callback-url)

This provides you with an OAuth Client ID and secret you can provide to Imperial.

### Imperial Integration

You can use GitHub with the `ImperialGitHub` package. This expects two environment variables:

* `GITHUB_CLIENT_ID`
* `GITHUB_CLIENT_SECRET`

You can then register the OAuth provider like normal.
