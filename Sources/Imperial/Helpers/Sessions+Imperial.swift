import Vapor
import Sessions

extension Request {
    public func getAccessToken()throws -> String {
        return try self.assertSession().getAccessToken()
    }
}

extension Session {
    public func getAccessToken()throws -> String {
        guard let token = self.data["access_token"]?.string else {
            throw Abort(.badRequest, reason: "User currently not authenticated")
        }
        return token
    }
}
