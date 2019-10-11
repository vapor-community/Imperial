import Vapor

public struct NetIDConfig {

    /// The route to register for the netID provider.
    /// To start netID authentication navigate here.
    var authenticate: String

    /// Something
    var authenticateCallback: ((Request) throws -> (Future<Void>))? = nil

    /// The path or URL that netID will redirect to after authentication.
    /// It is important that this URL is registered with netID.
    var callback: String

    /// Scopes: List of identifiers used to specify what access privileges are requested for the access token.
    /// Currently the only supported scope by netID is 'openid' which can be omitted because it will be added automatically.
    var scope: [String] = []

    /// Claims: List of identifiers used to specify what attributes of the subject will be requested.
    /// Currently supported claims by netID are 'gender', 'given_name', 'family_name', 'birthdate', 'email', 'email_verified' and 'address'.
    var claims: [String] = []

    /// Closure which will be called to generate the value of the state parameter for each authentication.
    /// It is highly recommended to specify this to mitigate CSRF attacks. The closure should return a string containing a unique and non-guessable value associated with each authentication.
    var state: ((Request) throws -> String)? = nil

    /// Closure which will be called to verify the value of the state parameter returned by netID after an authentication.
    /// It is mandatory to verify the state to mitigate CSRF attacks. With this closure this is done before an access token is requested. If omitted the verification MUST be performed in the completion handler of the authentication.
    var stateVerify: ((Request, String) throws -> Bool)?

    public init(
        authenticate: String,
        authenticateCallback: ((Request) throws -> (Future<Void>))? = nil,
        callback: String,
        scope: [String] = [],
        claims: [String] = [],
        state: ((Request) throws -> String)? = nil,
        stateVerify: ((Request, String) throws -> Bool)? = nil
    ) {
        self.authenticate = authenticate
        self.authenticateCallback = authenticateCallback
        self.callback = callback
        self.scope = scope
        self.claims = claims
        self.state = state
        self.stateVerify = stateVerify
    }

}
