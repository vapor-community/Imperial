# ``ImperialMixcloud``

Federated Authentication with Mixcloud for Vapor.

## Overview

### Mixcloud Setup

Start by going to the [Mixcloud Create new app page](https://www.mixcloud.com/developers/create/).
Fill in the your app information (as opposed to most other services, you do *not* have to register a callback URI).

This provides you with an OAuth Client ID and secret you can provide to Imperial.

### Imperial Integration

You can use Mixcloud with the `ImperialMixcloud` package. This expects two environment variables:

* `MIXCLOUD_CLIENT_ID`
* `MIXCLOUD_CLIENT_SECRET`

You can then register the OAuth provider like normal.
