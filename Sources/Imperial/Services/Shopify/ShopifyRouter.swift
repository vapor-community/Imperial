//
//  ShopifyRouter.swift
//  App
//
//  Created by David Muzi on 2018-12-27.
//

import Imperial
import Vapor

public class ShopifyRouter: FederatedServiceRouter {
	
	public let tokens: FederatedServiceTokens
	public let callbackCompletion: (Request, String) throws -> (Future<ResponseEncodable>)
	public var scope: [String] = []
	public let callbackURL: String
	public var accessTokenURL: String {
		return _accessTokenURL
	}
	public var authURL: String {
		return _authURL
	}
	
	public var _accessTokenURL: String!
	public var _authURL: String!
	private var nonce: String!
	
	required public init(callback: String, completion: @escaping (Request, String) throws -> (Future<ResponseEncodable>)) throws {
		self.tokens = try ShopifyAuth()
		self.callbackURL = callback
		self.callbackCompletion = completion
	}
	
	/// The route thats called to initiate the auth flow
	/// ex. https://78d55c18.ngrok.io/login-shopify?shop=davidmuzi.myshopify.com
	///
	/// - Parameter request: The request from the browser.
	/// - Returns: A response that, by default, redirects the user to `authURL`.
	/// - Throws: N/A
	public func authenticate(_ request: Request) throws -> Future<Response> {
		
		nonce = String(UUID().uuidString.prefix(6))
		authURLFrom(request)
		
		let redirect: Response = request.redirect(to: authURL)
		return request.eventLoop.newSucceededFuture(result: redirect)
	}
	
	/// Gets an access token from an OAuth provider.
	/// This method is the main body of the `callback` handler.
	///
	/// - Parameters: request: The request for the route this method is called in.
	public func fetchToken(from request: Request) throws -> EventLoopFuture<String> {
		
		// Extract the parameters to verify
		guard let code = request.query[String.self, at: "code"],
			let shop = request.query[String.self, at: "shop"],
			let hmac = request.query[String.self, at: "hmac"],
			let state = request.query[String.self, at: "state"] else { throw Abort(.badRequest) }

		// Verify the request
		guard state == nonce else { throw Abort(.badRequest) }
		guard URL(string: shop)?.isValidShopifyDomain() == true else { throw Abort(.badRequest) }
		guard request.http.url.generateHMAC(key: tokens.clientSecret) == hmac else { throw Abort(.badRequest) }
		
		setAccessTokenURLFrom(request)
		
		// obtain access token
		let body = ShopifyCallbackBody(code: code, clientId: tokens.clientID, clientSecret: tokens.clientSecret)
		return try body.encode(using: request).flatMap(to: Response.self) { request in
			guard let url = URL(string: self.accessTokenURL) else {
				throw Abort(.internalServerError, reason: "Unable to convert String '\(self.accessTokenURL)' to URL")
			}
			request.http.method = .POST
			request.http.url = url
			return try request.make(Client.self).send(request)
		}.flatMap(to: String.self) { response in
			return response.content.get(String.self, at: ["access_token"])
		}
	}
		
	/// The route that the OAuth provider calls when the user has benn authenticated.
	///
	/// - Parameter request: The request from the OAuth provider.
	/// - Returns: A response that should redirect the user back to the app.
	/// - Throws: An errors that occur in the implementation code.
	public func callback(_ request: Request) throws -> EventLoopFuture<Response> {

		return try self.fetchToken(from: request).flatMap(to: ResponseEncodable.self) { accessToken in
			
			guard let domain = request.query[String.self, at: "shop"] else { throw Abort(.badRequest) }
			
			let session = try request.session()
			session.setAccessToken(token: accessToken)
			session.setShopDomain(domain: domain)
			
			return try self.callbackCompletion(request, accessToken)
		}.flatMap(to: Response.self) { response in
			return try response.encode(for: request)
		}
	}
	
	private func authURLFrom(_ request: Request) {
		guard let shop = request.query[String.self, at: "shop"] else { return }
		
		_authURL = "https://\(shop)/admin/oauth/authorize?" + "client_id=\(tokens.clientID)&" +
			"scope=\(scope.joined(separator: ","))&" +
			"redirect_uri=\(callbackURL)&" +
		"state=\(nonce!)"
	}
	
	private func setAccessTokenURLFrom(_ request: Request) {
		guard let shop = request.query[String.self, at: "shop"] else { return }
		_accessTokenURL = "https://\(shop)/admin/oauth/access_token"
	}
}
