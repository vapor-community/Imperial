import class Vapor.Request
import class NIO.EventLoopFuture

extension Request {
    public var github: OAuthSession<GitHubOAuth> { .init(request: self) }
}


extension Request.OAuthSession where Service == GitHubOAuth {
    public func user<D>(as type: D.Type = D.self) -> EventLoopFuture<D> where D: Codable {
        return self.get(endpoint: \.$user, as: D.self)
    }
}
