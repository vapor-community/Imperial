import Vapor

extension Router {
    public func oAuth<OAuthProvider>(
        from provider: OAuthProvider.Type,
        authenticate authUrl: String,
        callback: String,
        scope: [String] = [],
        completion: @escaping (Request, String)throws -> Future<ResponseEncodable>
    )throws where OAuthProvider: FederatedService {
        _ = try OAuthProvider(router: self, authenticate: authUrl, callback: callback, scope: scope, completion: completion)
    }
    
    public func oAuth<OAuthProvider>(
        from provider: OAuthProvider.Type,
        authenticate authUrl: String,
        callback: String,
        scope: [String] = [],
        redirect redirectURL: String
    )throws where OAuthProvider: FederatedService {
        try self.oAuth(from: OAuthProvider.self, authenticate: authUrl, callback: callback, scope: scope) { (request, token) in
            let redirect: Response = request.redirect(to: redirectURL)
            return request.eventLoop.newSucceededFuture(result: redirect)
        }
    }
}
