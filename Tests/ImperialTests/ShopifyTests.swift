import Foundation
import Testing
import VaporTesting

@testable import ImperialShopify

@Suite("ImperialShopify Tests")
struct ShopifyTests {
    @Test("Shopify Route") func shopifyRoute() async throws {
        try await withApp(service: Shopify.self) { app in
            try await app.test(
                .GET, "\(authURL)?shop=some-shop.myshopify.com",
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET,
                "\(callbackURL)?"
                    + "code=0907a61c0c8d55e99db179b68161bc00&"
                    + "hmac=700e2dadb827fcc8609e9d5ce208b2e9cdaab9df07390d2cbca10d7c328fc4bf&"
                    + "shop=some-shop.myshopify.com&"
                    + "state=0.6784241404160823&"
                    + "timestamp=1337178173",
                afterResponse: { res async throws in
                    // The session should have the `nonce` property set
                    #expect(res.status == .badRequest)
                }
            )
        }
    }

    @Test("Valid Shopify Domain") func domainCheck() throws {
        let domain = "davidmuzi.myshopify.com"
        #expect(URL(string: domain)!.isValidShopifyDomain)

        let domain2 = "d4m3.myshopify.com"
        #expect(URL(string: domain2)!.isValidShopifyDomain)

        let domain3 = "david-muzi.myshopify.com"
        #expect(URL(string: domain3)!.isValidShopifyDomain)

        let domain4 = "david.muzi.myshopify.com"
        #expect(URL(string: domain4)!.isValidShopifyDomain)

        let domain5 = "david#muzi.myshopify.com"
        #expect(!URL(string: domain5)!.isValidShopifyDomain)

        let domain6 = "davidmuzi.myshopify.com.ca"
        #expect(!URL(string: domain6)!.isValidShopifyDomain)

        let domain7 = "davidmuzi.square.com"
        #expect(!URL(string: domain7)!.isValidShopifyDomain)

        let domain8 = "david*muzi.shopify.ca"
        #expect(!URL(string: domain8)!.isValidShopifyDomain)
    }

    @Test("HMAC Validation") func hmacValidation() throws {
        let url = URL(
            string: "https://domain.com/?"
                + "code=0907a61c0c8d55e99db179b68161bc00&"
                + "hmac=700e2dadb827fcc8609e9d5ce208b2e9cdaab9df07390d2cbca10d7c328fc4bf&"
                + "shop=some-shop.myshopify.com&"
                + "state=0.6784241404160823&"
                + "timestamp=1337178173"
        )!

        let hmac = url.generateHMAC(key: "hush")
        #expect(hmac == "700e2dadb827fcc8609e9d5ce208b2e9cdaab9df07390d2cbca10d7c328fc4bf")
    }
}
