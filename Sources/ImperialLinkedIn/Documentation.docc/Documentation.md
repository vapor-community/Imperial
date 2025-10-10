# ``ImperialLinkedIn``

Federated Authentication with linkedin for Vapor.

## Overview

### Linkedin setup

**Register your app on LinkedIn Developer Portal**
   - Add the product: **Sign In with LinkedIn**
   - Set your redirect URI (e.g., `https://yourdomain.com/auth/linkedin/callback`)
   - Ensure scopes: `openid`, `profile`, `email`

### Imperial Integration

You can use Keycloak with the `ImperialLinkedIn` package. This expects two environment variables:

* `LINKEDIN_CLIENT_ID=your_client_id`
* `LINKEDIN_CLIENT_SECRET=your_client_secret`

