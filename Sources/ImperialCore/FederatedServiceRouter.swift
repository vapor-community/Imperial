import Foundation
import Vapor

/// Defines a type that implements the routing to get an access token from an OAuth provider.
/// See implementations in the `Services/(Google|GitHub)/$0Router.swift` files
package protocol FederatedServiceRouter: Sendable {
    typealias AccessToken = FederatedService.AccessToken
    typealias ResponseBody = FederatedService.ResponseBody
    
    /// An object that gets the client ID and secret from environment variables.
    var tokens: any FederatedServiceTokens { get }

    /// The callback that is fired after the access token is fetched from the OAuth provider.
    /// The response that is returned from this callback is also returned from the callback route.
    var callbackCompletion: @Sendable (Request, AccessToken, ResponseBody?) async throws -> any AsyncResponseEncodable { get }

    /// The key to acess the code URL query parameter
    var codeKey: String { get }

    /// The key to acess the error URL query parameter
    var errorKey: String { get }

    /// The URL (or URI) for that route that the provider will fire when the user authenticates with the OAuth provider.
    var callbackURL: String { get }

    /// HTTPHeaders for the Callback request
    var callbackHeaders: HTTPHeaders { get }

    /// The URL on the app that will redirect to the `authURL` to get the access token from the OAuth provider.
    var accessTokenURL: String { get }

    /// The URL components of the page that the user will be redirected to to get the access token.
    func authURLComponents(_ request: Request) throws -> URLComponents
    
    /// Creates an instence of the type implementing the protocol.
    ///
    /// - Parameters:
    ///   - options: Options to supply the provider when making a request.
    ///   - completion: The completion handler that will be fired at the end of the `callback` route. The access token and response body are passed into it.
    /// - Throws: Any errors that could occur in the implementation.
    init(
        options: some FederatedServiceOptions,
        completion: @escaping @Sendable (Request, AccessToken, ResponseBody?) async throws -> some AsyncResponseEncodable
    ) throws

    /// Configures the `authenticate` and `callback` routes with the droplet.
    ///
    /// - Parameters:
    ///   - authURL: The URL for the route that will redirect the user to the OAuth provider.
    ///   - authenticateCallback: Execute custom code within the authenticate closure before redirection.
    ///   - router: The router to configure the routes on.
    /// - Throws: N/A
    func configureRoutes(
        withAuthURL authURL: String,
        authenticateCallback: (@Sendable (Request) async throws -> Void)?,
        on router: some RoutesBuilder
    ) throws

    /// Gets an access token and response body from an OAuth provider.
    /// This method is the main body of the `callback` handler.
    ///
    /// - Parameters: request: The request for the route
    ///   this method is called in.
    /// - Returns: A tuple with the access token and provider's response body.
    func fetchTokenAndResponseBody(from request: Request) async throws -> (AccessToken, ResponseBody?)

    /// Creates CallbackBody with authorization code
    func callbackBody(with code: String) -> any AsyncResponseEncodable

    /// The route that the OAuth provider calls when the user has been authenticated.
    ///
    /// - Parameter request: The request from the OAuth provider.
    /// - Returns: A response that should redirect the user back to the app.
    /// - Throws: An errors that occur in the implementation code.
    @Sendable func callback(_ request: Request) async throws -> Response
    
    /// Retrieve refresh token from provider's response body.
    /// - Parameter body: The body of the provider's response.
    /// - Returns: An optional string.
    func refreshToken(_ body: ResponseBody?) -> String?
}

extension FederatedServiceRouter {
    package var codeKey: String { "code" }
    package var errorKey: String { "error" }
    package var callbackHeaders: HTTPHeaders { [:] }

    package func configureRoutes(
        withAuthURL authURL: String, authenticateCallback: (@Sendable (Request) async throws -> Void)?, on router: some RoutesBuilder
    ) throws {
        router.get(callbackURL.pathSegments, use: callback)
        router.get(authURL.pathSegments) { req async throws -> Response in
            /// add state query item to url
            var authURLComponents = try authURLComponents(req)
            let state = req.session.setState(count: 30)
            if let queryItems = authURLComponents.queryItems {
                authURLComponents.queryItems = queryItems + [.init(state: state)]
            }
            // convert components to URL
            guard let authURL = authURLComponents.url else {
                throw Abort(.internalServerError)
            }
            let redirect: Response = req.redirect(to: authURL.absoluteString)
            guard let authenticateCallback else {
                return redirect
            }
            try await authenticateCallback(req)
            return redirect
        }
    }

    package func fetchTokenAndResponseBody(from request: Request) async throws -> (AccessToken, ResponseBody?) {
        let code: String
        if let queryCode: String = try request.query.get(at: codeKey) {
            code = queryCode
        } else if let error: String = try request.query.get(at: errorKey) {
            throw Abort(.badRequest, reason: error)
        } else {
            throw Abort(.badRequest, reason: "Missing 'code' key in URL query")
        }

        let body = callbackBody(with: code)
        let url = URI(string: accessTokenURL)

        let buffer = try await body.encodeResponse(for: request).body.buffer
        let response = try await request.client.post(url, headers: self.callbackHeaders) { $0.body = buffer }
        let responseBody: String? = response.body != nil ? .init(buffer: response.body!) : nil
        let token = try response.content.get(String.self, at: ["access_token"])
        return (token, responseBody)
    }
    
    /// Compare state value returned by provider in url parameter to the one saved in the session.
    package func verifyState(_ request: Request) throws {
        guard let requestState = request.query[String.self, at: "state"],
              let sessionState = request.session.state,
              requestState == sessionState else {
            throw Abort(.badRequest)
        }
    }

    package func callback(_ request: Request) async throws -> Response {
        try verifyState(request)
        let (accessToken, responseBody) = try await self.fetchTokenAndResponseBody(from: request)
        let session = request.session
        try session.setAccessToken(accessToken)
        if let refreshToken = refreshToken(responseBody) {
            session.setRefreshToken(refreshToken)
        }
        let response = try await self.callbackCompletion(request, accessToken, responseBody)
        return try await response.encodeResponse(for: request)
    }
    
    /// Default implementation. Provider can implement depending on its response body.
    package func refreshToken(_ responseBody: ResponseBody?) -> String? {
        return nil
    }
}
