# ``ImperialLinkedIn``

Federated Authentication with LinkedIn for Vapor.

## Overview

### LinkedIn setup

1. Register your app on the LinkedIn developer portal
2. Add the product "Sign in with LinkedIn"
3. Set your redirect URI (e.g., `https://yourdomain.com/auth/linkedin/callback`)
4. Set scopes `openid`, `profile` and `email`


### LinkedIn API

[Developer documentation](https://learn.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/sign-in-with-linkedin-v2?context=linkedin%2Fconsumer%2Fcontext)


### Expected environment variables

Imperial expects two environment variables:

* `LINKEDIN_CLIENT_ID=your_client_id`
* `LINKEDIN_CLIENT_SECRET=your_client_secret`

### Integration example

```swift
Import Vapor 

struct LinkedInUserInfo: Content {
   let sub: String
   let given_name: String?
   let family_name: String?
   let picture: String?
   let email: String
   let email_verified: Bool?
   let locale: LinkedInLocale?
}

struct LinkedInLocale: Content {
   let country: String?
   let language: String?
}

struct LinkedInImperialRouter: RouteCollection {

   func boot(routes: RoutesBuilder) throws {

      try routes.oAuth(
         from: LinkedIn.self,
         authenticate: "auth2/linkedin/",
         callback: yourCustomCallbackPath,
         scope: ["openid","profile","email"],
         completion: processLinkedInLogin
      )
   }

   func processLinkedInLogin(request: Request, token: String) async throws -> Response {

      let userInfo = try await LinkedIn.getUser(on: request)

      // Your own user management implementation
      var user = try await User
         .query(on: request.db)
         .filter(\.$username == userInfo.sub)
         .first()

      // You might update and save your user data

}

extension LinkedIn {

   static func getUser(on request: Request) async throws -> LinkedInUserInfo {
      var headers = HTTPHeaders()
      headers.bearerAuthorization = try BearerAuthorization(token: request.accessToken)

      let userInfoURL: URI = "https://api.linkedin.com/v2/userinfo"
      let response = try await request.client.get(userInfoURL, headers: headers)
      print(response)
      let userInfo = try response.content.decode(LinkedInUserInfo.self)

      request.logger.debug("\(userInfo)")

      guard response.status == .ok else {
         throw Abort(.unauthorized)
      }

      return userInfo
   }
}
```


