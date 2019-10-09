import Vapor

public struct NetIDConfig {

    var authenticate: String
    var authenticateCallback: ((Request) throws -> (Future<Void>))? = nil
    var callback: String
    var scope: [String] = []
    var claims: [String] = []
    var state: ((Request) throws -> String)? = nil

    public init(
        authenticate: String,
        authenticateCallback: ((Request) throws -> (Future<Void>))? = nil,
        callback: String,
        scope: [String] = [],
        claims: [String] = [],
        state: ((Request) throws -> String)? = nil
    ) {
        self.authenticate = authenticate
        self.authenticateCallback = authenticateCallback
        self.callback = callback
        self.scope = scope
        self.claims = claims
        self.state = state
    }

}
