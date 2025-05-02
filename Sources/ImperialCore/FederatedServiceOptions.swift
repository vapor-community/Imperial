import Foundation

/// Protocol to standardize the minimum set of options for each FederatedService.
/// Each provider can create a custom options object with many more features if necessary.
/// Implementing this protocol allows it to be used as a FederatedService parameter.
public protocol FederatedServiceOptions {
    /// The callback URL that the OAuth provider will redirect to after authenticating the user.
    var callback: String { get }
    
    /// The scopes to get access to on authentication. It gets converted into a URL query item.
    var scope: [String] { get }
    
    /// The query items attached to the provider's URL.
    var queryItems: [URLQueryItem] { get }
    
    /// Initializer
    /// - Parameters:
    ///   - callback: The callback URL that the OAuth provider will redirect to after authenticating the user.
    ///   - scope: The scopes to get access to on authentication. It gets converted into a URL query item.
    init(callback: String, scope: [String]) throws
}
