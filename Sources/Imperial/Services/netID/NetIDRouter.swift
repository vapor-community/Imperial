import Vapor
import Foundation

public class NetIDRouter: FederatedServiceRouter {

    public let tokens: FederatedServiceTokens
    public let callbackCompletion: (Request, String) throws -> (Future<ResponseEncodable>)
    public var scope: [String] = []
    public var claims: [String] = []
    public var state: ((Request) throws -> String)?
    public let callbackURL: String
    public let accessTokenURL: String = "https://broker.netid.de/token"
    
    public required init(
        callback: String,
        completion: @escaping (Request, String) throws -> (Future<ResponseEncodable>)
    ) throws {
        self.tokens = try NetIDAuth()
        self.callbackURL = callback
        self.callbackCompletion = completion
    }

    private func scopeValue() throws -> String {
        var scope = self.scope
        if !scope.contains("openid") {
            scope.append("openid")
        }
        return scope.joined(separator: " ")
    }
    
    private func claimsValue() throws -> String {
        var userinfo = [String: Any]()
        for claim in claims {
            userinfo[claim] = [ "essential": true ]
        }
        let claims: [String: Any] = [ "userinfo": userinfo ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: claims) else {
            throw Abort(.badRequest, reason: "Encoding claims to JSON data failed!")
        }
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw Abort(.badRequest, reason: "Encoding claims to JSON string failed!")
        }
        return jsonString
    }
    
    public func authURL(_ request: Request) throws -> String {
        var url = URLComponents()
        url.scheme = "https"
        url.host = "broker.netid.de"
        url.path = "/authorize"
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "client_id", value: "\(self.tokens.clientID)"))
        queryItems.append(URLQueryItem(name: "redirect_uri", value: "\(self.callbackURL)"))
        queryItems.append(URLQueryItem(name: "scope", value: try scopeValue()))
        queryItems.append(URLQueryItem(name: "claims", value: try claimsValue()))
        queryItems.append(URLQueryItem(name: "response_type", value: "code"))
        if let state = state {
            let stateValue = try state(request)
            queryItems.append(URLQueryItem(name: "state", value: stateValue))
        }
        url.queryItems = queryItems
        guard let urlstring = url.string else {
            throw Abort(.badRequest, reason: "Can't build authURL")
        }
        return urlstring
    }
    
    public func fetchToken(from request: Request)throws -> Future<String> {
        let code: String
        if let queryCode: String = try request.query.get(at: "code") {
            code = queryCode
        } else if let error: String = try request.query.get(at: "error") {
            throw Abort(.badRequest, reason: error)
        } else {
            throw Abort(.badRequest, reason: "Missing 'code' key in URL query")
        }
        
        let body = NetIDCallbackBody(code: code, redirectURI: self.callbackURL)
        return try body.encode(using: request).flatMap(to: Response.self) { request in
            guard let url = URL(string: self.accessTokenURL) else {
                throw Abort(.internalServerError, reason: "Unable to convert String '\(self.accessTokenURL)' to URL")
            }
            request.http.method = .POST
            request.http.url = url
            request.http.headers.basicAuthorization = BasicAuthorization(
                username: self.tokens.clientID,
                password: self.tokens.clientSecret
            )
            return try request.make(Client.self).send(request)
        }.flatMap(to: String.self) { response in
            return response.content.get(String.self, at: ["access_token"])
        }
    }
    
    public func callback(_ request: Request)throws -> Future<Response> {
        return try self.fetchToken(from: request)
            .flatMap(to: ResponseEncodable.self) { accessToken in
                let session = try request.session()
                
                session.setAccessToken(accessToken)
                try session.set("access_token_service", to: OAuthService.netid)
                
                return try self.callbackCompletion(request, accessToken)
            }.flatMap(to: Response.self) { response in
                return try response.encode(for: request)
            }
    }

}
