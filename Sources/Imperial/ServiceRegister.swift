import Vapor

extension Router {
    func oAuth<OAuthProvider>(
        from provider: OAuthProvider.Type,
        authenticate authUrl: String,
        callback: String,
        scope: [String] = [],
        completion: @escaping (String)throws -> Future<ResponseEncodable>
    )throws where OAuthProvider: FederatedService {
        _ = try OAuthProvider(router: self, authenticate: authUrl, callback: callback, scope: scope, completion: completion)
    }
}
