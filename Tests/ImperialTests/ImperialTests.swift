import ImperialAuth0
import ImperialDeviantArt
import ImperialDiscord
import ImperialDropbox
import ImperialFacebook
import ImperialGitHub
import ImperialGitlab
import ImperialGoogle
import ImperialImgur
import ImperialKeycloak
import ImperialMicrosoft
import ImperialMixcloud
import Testing
import VaporTesting

@testable import ImperialCore

@Suite("Imperial Tests", .serialized)
struct ImperialTests {
    @Test("Auth0 Route")
    func auth0Route() async throws {
        try await withApp(service: Auth0.self) { app in
            try await app.test(
                .GET, authURL,
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "\(callbackURL)?code=123",
                afterResponse: { res async throws in
                    // A real Auth0 domain is needed to test this route
                    #expect(res.status == .internalServerError)
                }
            )
        }
    }

    @Test("DeviantArt Route")
    func deviantArtRoute() async throws {
        try await withApp(service: DeviantArt.self) { app in
            try await app.test(
                .GET, authURL,
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "\(callbackURL)?code=123",
                afterResponse: { res async throws in
                    // TODO: test this route
                    #expect(res.status != .notFound)
                }
            )
        }
    }

    @Test("Discord Route")
    func discordRoute() async throws {
        try await withApp(service: Discord.self) { app in
            try await app.test(
                .GET, authURL,
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "\(callbackURL)?code=123",
                afterResponse: { res async throws in
                    // Discord returns a 400 Bad Request error when the code is invalid with a JSON error message
                    #expect(res.status == .badRequest)
                }
            )
        }
    }

    @Test("Dropbox Route")
    func dropboxRoute() async throws {
        try await withApp(service: Dropbox.self) { app in
            try await app.test(
                .GET, authURL,
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "\(callbackURL)?code=123",
                afterResponse: { res async throws in
                    // Dropbox returns a 400 Bad Request error when the code is invalid with a JSON error message
                    #expect(res.status == .badRequest)
                }
            )
        }
    }

    @Test("Facebook Route")
    func facebookRoute() async throws {
        try await withApp(service: Facebook.self) { app in
            try await app.test(
                .GET, authURL,
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "\(callbackURL)?code=123",
                afterResponse: { res async throws in
                    // The response is an JS, signaling an error with `redirect_uri`
                    #expect(res.status == .unsupportedMediaType)
                }
            )
        }
    }

    @Test("GitHub Route")
    func githubRoute() async throws {
        try await withApp(service: GitHub.self) { app in
            try await app.test(
                .GET, authURL,
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "\(callbackURL)?code=123",
                afterResponse: { res async throws in
                    // The response is an HTML page likely signaling an error
                    #expect(res.status == .unsupportedMediaType)
                }
            )
        }
    }

    @Test("Gitlab Route")
    func gitlabRoute() async throws {
        try await withApp(service: Gitlab.self) { app in
            try await app.test(
                .GET, authURL,
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "\(callbackURL)?code=123",
                afterResponse: { res async throws in
                    // Gitlab returns a 400 Bad Request error when the code is invalid with a JSON error message
                    #expect(res.status == .badRequest)
                }
            )
        }
    }

    @Test("Google Route")
    func googleRoute() async throws {
        try await withApp(service: Google.self) { app in
            try await app.test(
                .GET, authURL,
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "\(callbackURL)?code=123",
                afterResponse: { res async throws in
                    // Google returns a 400 Bad Request error when the code is invalid with a JSON error message
                    #expect(res.status == .badRequest)
                }
            )
        }
    }

    @Test("Google JWT Route")
    func googleJWTRoute() async throws {
        try await withApp(service: GoogleJWT.self) { app in
            try await app.test(
                .GET, authURL,
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, callbackURL,
                afterResponse: { res async throws in
                    // We don't have a valid key to sign the JWT
                    #expect(res.status == .internalServerError)
                }
            )
        }
    }

    @Test("Imgur Route")
    func imgurRoute() async throws {
        try await withApp(service: Imgur.self) { app in
            try await app.test(
                .GET, authURL,
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "\(callbackURL)?code=123",
                afterResponse: { res async throws in
                    // TODO: test this route
                    #expect(res.status != .notFound)
                }
            )
        }
    }

    @Test("Keycloak Route")
    func keycloakRoute() async throws {
        try await withApp(service: Keycloak.self) { app in
            try await app.test(
                .GET, authURL,
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "\(callbackURL)?code=123",
                afterResponse: { res async throws in
                    // The post request fails
                    #expect(res.status == .internalServerError)
                }
            )
        }
    }

    @Test("Microsoft Route")
    func microsoftRoute() async throws {
        try await withApp(service: Microsoft.self) { app in
            try await app.test(
                .GET, authURL,
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "\(callbackURL)?code=123",
                afterResponse: { res async throws in
                    // Microsoft returns a 400 Bad Request, signaling an error with `redirect_uri`
                    #expect(res.status == .badRequest)
                }
            )
        }
    }

    @Test("Mixcloud Route")
    func mixcloudRoute() async throws {
        try await withApp(service: Mixcloud.self) { app in
            try await app.test(
                .GET, authURL,
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "\(callbackURL)?code=123",
                afterResponse: { res async throws in
                    // TODO: test this route
                    #expect(res.status != .notFound)
                }
            )
        }
    }

    @Test("Path Segments")
    func pathSegments() {
        let url = "https://hello.world.example.com:8080/api/oauth/service-auth-complete"
        #expect(url.pathSegments == ["api", "oauth", "service-auth-complete"])
        #expect(url.pathSegments.string == "api/oauth/service-auth-complete")
    }

    @Test("ImperialError")
    func imperialError() {
        let variable = "test"
        let imperialError = ImperialError.missingEnvVar(variable)
        #expect(
            imperialError.description
                == "ImperialError(errorType: \(imperialError.errorType.base.rawValue), missing enviroment variable: \(variable))"
        )
        #expect(ImperialError.missingEnvVar("foo") == ImperialError.missingEnvVar("bar"))
    }
}
