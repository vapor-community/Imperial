import Vapor

public class ImperialMiddleware: Middleware {
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        _ = try request.getAccessToken()
        return try next.respond(to: request)
    }
}
