import Vapor

/// Protects routes from users without an access token.
public class ImperialMiddleware: Middleware {
    
    /// The path to redirect the user to if they are not authenticated.
    let redirectPath: String?
    /// The Middleware for responding after error
    let onErrorMiddleware: Middleware?
    
    /// Creates an instance of `ImperialMiddleware` with the option of a redirect path.
    ///
    /// - Parameter redirect: The path to redirect a user to if they do not have an access token.
    /// - Parameter onErrorMiddleware: The middleware for responding on oAuth error (might be used for e.g. for  manual Authenticable)
    public init(redirect: String? = nil, onErrorMiddleware: Middleware? = nil) {
        self.redirectPath = redirect
        self.onErrorMiddleware = onErrorMiddleware
    }
    
    /// Checks that the request contains an access token. If it does, let the request through.
    /// If not, calls respond method from `onErrorMiddleware` if it exists. if not, redirect the user to the `redirectPath`.
    /// If the `redirectPath` is `nil`, then throw the error from getting the access token (Abort.unauthorized).
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        do {
            _ = try request.accessToken()
            return next.respond(to: request)
        } catch let error as Abort where error.status == .unauthorized {
            guard let onErrorMiddleware = onErrorMiddleware else {
                guard let redirectPath = redirectPath else {
                    return request.eventLoop.makeFailedFuture(error)
                }
                let redirect: Response = request.redirect(to: redirectPath)
                return request.eventLoop.makeSucceededFuture(redirect)
            }
            return onErrorMiddleware.respond(to: request, chainingTo: next)
        } catch let error {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
}
