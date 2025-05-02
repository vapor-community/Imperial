import Vapor

extension Request {
    /// Gets the access token from the current session.
    public var accessToken: String {
        get throws {
            try session.accessToken
        }
    }

    /// Gets the refresh token from the current session.
    public var refreshToken: String {
        get throws {
            try session.refreshToken
        }
    }
}

extension Session {
    /// Keys used to store and retrieve items from the session
    enum Keys {
        static let token = "access_token"
        static let refresh = "refresh_token"
        static let state = "state"
    }

    /// Gets the access token from the session.
    public var accessToken: String {
        get throws {
            guard let token = try? get(Keys.token, as: String.self) else {
                throw Abort(.unauthorized, reason: "User currently not authenticated")
            }
            return token
        }
    }

    /// Sets the access token on the session.
    ///
    /// - Parameter token: the access token to store on the session
    public func setAccessToken(_ token: String) throws {
        try set(Keys.token, to: token)
    }

    /// Gets the refresh token from the session.
    public var refreshToken: String {
        get throws {
            guard let token = self.data[Keys.refresh] else {
                if self.data[Keys.token] == nil {
                    throw Abort(.unauthorized, reason: "User currently not authenticated")
                } else {
                    throw Abort(.methodNotAllowed)
                }
            }
            return token
        }
    }

    /// Sets the refresh token on the session.
    ///
    /// - Parameter token: the refresh token to store on the session
    public func setRefreshToken(_ token: String) {
        self.data[Keys.refresh] = token
    }
    
    /// Sets and returns random state value in the session.
    ///
    /// - Parameters:
    ///   - count: Number of characters in returned string
    public func setState(count: Int = 32) -> String {
        let state = String(UUID().uuidString.prefix(count))
        self.data[Keys.state] = state
        return state
    }
    
    /// Retrieves and removes state value from the session.
    public var state: String? {
        let state = self.data[Keys.state]
        self.data[Keys.state] = nil
        return state
    }

    /// Gets an object stored in a session with JSON as a given type.
    ///
    /// - Parameters:
    ///   - key: The key for the object stored in the session, similar to a dictionary.
    ///   - type: The type to convert the stored JSON to.
    /// - Returns: The JSON from the session, decoded to the type passed in.
    /// - Throws: Errors when no object is stored in the session with the given key, or decoding fails.
    package func get<T>(_ key: String, as type: T.Type) throws -> T where T: Codable {
        guard let stored = data[key] else {
            if _isOptional(T.self) { return Optional<Void>.none as! T }
            throw Abort(.internalServerError, reason: "No element found in session with key '\(key)'")
        }
        return try JSONDecoder().decode(T.self, from: Data(stored.utf8))
    }

    /// Sets a key in the session to a codable object.
    ///
    /// - Parameters:
    ///   - key: The key to store the object at, as you would in a dictionary.
    ///   - data: The object to store.
    /// - Throws: Errors that occur when encoding the object.
    package func set<T>(_ key: String, to data: T) throws where T: Codable {
        let val = try String(data: JSONEncoder().encode(data), encoding: .utf8)
        self.data[key] = val
    }
}
