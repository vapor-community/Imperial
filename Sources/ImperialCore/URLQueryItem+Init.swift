import Foundation

/// Convenience initializers for FederatedServiceRouter
extension URLQueryItem {
    package init(clientID: String) {
        self.init(name: "client_id", value: clientID)
    }
    
    package init(redirectURIItem callbackURL: String) {
        self.init(name: "redirect_uri", value: callbackURL)
    }
    
    package static var codeResponseTypeItem: URLQueryItem {
        .init(name: "response_type", value: "code")
    }
}
