import Foundation
import Vapor

extension Request {
    
    /// Gets the access token from the current session.
    ///
    /// - Returns: The access token in the current session.
    /// - Throws:
    ///   - `Abort.unauthorized` if no access token exists.
    ///   - `SessionsError.notConfigured` if session middlware is not configured yet.
    public func accessToken()throws -> String {
        return try self.session().accessToken()
    }
}

extension Session {
	
	enum Keys {
		static let token = "access_token"
	}
	
    /// Gets the access token from the session.
    ///
    /// - Returns: The access token stored with the `access_token` key.
    /// - Throws: `Abort.unauthorized` if no access token exists.m
    public func accessToken()throws -> String {
        guard let token = self[Keys.token] else {
            throw Abort(.unauthorized, reason: "User currently not authenticated")
        }
        return token
    }
	
	
	/// Sets the access token on the session.
	///
	/// - Parameter token: the access token to store on the session
	public func setAccessToken(_ token: String) {
		self[Keys.token] = token
	}
    
    /// Gets an object stored in a session with JSON as a given type.
    ///
    /// - Parameters:
    ///   - key: The key for the object stored in the session, similar to a dictionary.
    ///   - type: The type to convert the stored JSON to.
    /// - Returns: The JSON from the session, decoded to the type passed in.
    /// - Throws: Errors when no object is stored in the session with the given key, or decoding fails.
    public func get<T>(_ key: String, as type: T.Type)throws -> T where T: Codable {
        guard let stored = self[key] else {
            throw Abort(.internalServerError, reason: "No element found in session with ket '\(key)'")
        }
        return try JSONDecoder().decode(T.self, from: Data(stored.utf8))
    }
    
    /// Sets a key in the session to a codable object.
    ///
    /// - Parameters:
    ///   - key: The key to store the object at, as you would in a dictionary.
    ///   - data: The object to store.
    /// - Throws: Errors that occur when encoding the object.
    public func set<T>(_ key: String, to data: T)throws where T: Codable {
        self[key] = try String(data: JSONEncoder().encode(data), encoding: .utf8)
    }
}
