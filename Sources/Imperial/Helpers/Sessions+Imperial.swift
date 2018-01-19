import Vapor

extension Request {
    
    /// Gets the access token from the current session.
    ///
    /// - Returns: The access token in the current session.
    /// - Throws:
    ///   - `Abort.unauthorized` if no access token exists.
    ///   - `SessionsError.notConfigured` if session middlware is not configured yet.
    public func getAccessToken()throws -> String {
        return try self.session().getAccessToken()
    }
}

extension Session {
    
    /// Gets the access token from the session.
    ///
    /// - Returns: The access token stored with the `access_token` key.
    /// - Throws: `Abort.unauthorized` if no access token exists.m
    public func getAccessToken()throws -> String {
        guard let token = self["access_token"] else {
            throw Abort(.unauthorized, reason: "User currently not authenticated")
        }
        return token
    }
}
