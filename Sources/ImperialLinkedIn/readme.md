# LinkedIn Sign-In Extension for Imperial

This package extends [Imperial](https://github.com/vapor-community/Imperial) with support for **Sign In with LinkedIn** using the latest OpenID Connect-based API.

## 🔧 Requirements

- Vapor 4+
- Imperial 2.1.0+
- LinkedIn Developer Account
- Environment variables:
  - `LINKEDIN_CLIENT_ID`
  - `LINKEDIN_CLIENT_SECRET`

## 🚀 Setup

1. **Register your app on LinkedIn Developer Portal**
   - Add the product: **Sign In with LinkedIn**
   - Set your redirect URI (e.g., `https://yourdomain.com/auth/linkedin/callback`)
   - Ensure scopes: `openid`, `profile`, `email`

2. **Add environment variables**
   ```bash
   export LINKEDIN_CLIENT_ID=your_client_id
   export LINKEDIN_CLIENT_SECRET=your_client_secret
