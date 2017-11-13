import Vapor

public class ImperialMiddleware: Middleware {
    let redirectPath: String?
    
    public init(redirect: String? = nil) {
        self.redirectPath = redirect
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        do {
            _ = try request.getAccessToken()
            return try next.respond(to: request)
        } catch let error {
            if redirectPath != nil {
                return Response(redirect: redirectPath!)
            } else {
                throw error
            }
        }
    }
}
