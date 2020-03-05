import Vapor
import Foundation

public class Auth0Router: FederatedServiceRouter {
    public let baseURL: String
    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)
    public var scope: [String] = [ ]
    public var requiredScopes = [ "openid" ]
    public let callbackURL: String
    public let accessTokenURL: String

    private func providerUrl(path: String) -> String {
        return self.baseURL.finished(with: "/") + path
    }
    
    public required init(callback: String, completion: @escaping (Request, String) throws -> (EventLoopFuture<ResponseEncodable>)) throws {
        let auth = try Auth0Auth()
        self.tokens = auth
        self.baseURL = "https://\(auth.domain)"
        self.accessTokenURL = baseURL.finished(with: "/") + "oauth/token"
        self.callbackURL = callback
        self.callbackCompletion = completion
    }
    
    public func authURL(_ request: Request) throws -> String {
        let path="authorize"

        var params=[
            "response_type=code",
            "client_id=\(self.tokens.clientID)",
            "redirect_uri=\(self.callbackURL)",
        ]

        let allScopes = self.scope + self.requiredScopes
        let scopeString = allScopes.joined(separator: " ").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        if let scopes = scopeString {
            params += [ "scope=\(scopes)" ]
        }

        let rtn = self.providerUrl(path: path + "?" + params.joined(separator: "&"))
        return rtn
    }
    
    public func fetchToken(from request: Request)throws -> EventLoopFuture<String> {
        let code: String
        if let queryCode: String = try request.query.get(at: "code") {
            code = queryCode
        } else if let error: String = try request.query.get(at: "error") {
            throw Abort(.badRequest, reason: error)
        } else {
            throw Abort(.badRequest, reason: "Missing 'code' key in URL query")
        }
        
        let body = Auth0CallbackBody(clientId: self.tokens.clientID,
                                     clientSecret: self.tokens.clientSecret,
                                     code: code,
                                     redirectURI: self.callbackURL)
        		
		let url = URI(string: self.accessTokenURL)
		return body.encodeResponse(for: request).map {
			$0.body
		}.flatMap { body in
			return request.client.post(url, beforeSend: { client in
				client.body = body.buffer
			})
        }.flatMapThrowing { response in
			return try response.content.get(String.self, at: ["access_token"])
		}
    }
    
    public func callback(_ request: Request)throws -> EventLoopFuture<Response> {
		return try self.fetchToken(from: request).flatMap { accessToken in
			  let session = request.session
			  do {
				  try session.setAccessToken(accessToken)
				  try session.set("access_token_service", to: OAuthService.auth0)
				  return try self.callbackCompletion(request, accessToken).flatMap { response in
					  return response.encodeResponse(for: request)
				  }
			  } catch {
				  return request.eventLoop.makeFailedFuture(error)
			  }
		  }
    }
}
