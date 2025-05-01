import Foundation

/// Convenience initializers for FederatedServiceRouter
extension URLQueryItem {
    package static var codeResponseTypeItem: URLQueryItem {
        .init(name: "response_type", value: "code")
    }
    
    package init(clientID: String) {
        self.init(name: "client_id", value: clientID)
    }
    
    package init(redirectURIItem callbackURL: String) {
        self.init(name: "redirect_uri", value: callbackURL)
    }
    
    package init(scope: [String], separator: String) {
        self.init(name: "scope", value: scope.joined(separator: separator))
    }
    
    package init(state: String) {
        self.init(name: "state", value: state)
    }
}
