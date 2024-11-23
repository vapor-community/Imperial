import Vapor

extension Session {
    enum XKey {
        static let state = "x_state"
        static let codeChallenge = "x_code_challenge"
    }

    func setState(_ state: String?) throws {
        try self.set(XKey.state, to: state)
    }

    func state() -> String? {
        return try? self.get(XKey.state, as: String.self)
    }
    
    func setCodeChallenge(_ challenge: String?) throws {
        try self.set(XKey.codeChallenge, to: challenge)
    }
    
    func codeChallenge() -> String? {
        return try? self.get(XKey.codeChallenge, as: String.self)
    }
}