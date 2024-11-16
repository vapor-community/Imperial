import ImperialGitHub
import ImperialGoogle
import ImperialFacebook
import ImperialKeycloak
import ImperialDiscord
import ImperialAuth0
import Testing

@testable import ImperialCore

@Suite("ImperialCore Tests")
struct ImperialTests {
    @Test("ImperialError & ServiceError")
    func errors() {
        #expect(ImperialError.missingEnvVar("test").description == "ImperialError(errorType: missingEnvVar, missing enviroment variable: test)")
        #expect(ImperialError.missingEnvVar("foo") == ImperialError.missingEnvVar("bar"))

        #expect(ServiceError.noServiceFound("test").description == "ServiceError(errorType: noServiceFound, no service was found with the name: test)")
        #expect(ServiceError.noServiceEndpoint("test").description == "ServiceError(errorType: noServiceEndpoint, service does not have available endpoint for key: test)")
        #expect(ServiceError.noServiceFound("foo") == ServiceError.noServiceFound("bar"))
        #expect(ServiceError.noServiceEndpoint("foo") == ServiceError.noServiceEndpoint("bar"))
    }

    @Test("GitHub Route")
    func githubRoute() async throws {
        try await withApp { app in
            try await app.test(.GET, "/github", afterResponse: { res async throws in
				#expect(res.status == .notFound)
			})

            try app.oAuth(from: GitHub.self, authenticate: "github", callback: "gh-auth-complete", redirect: "/")

            try await app.test(.GET, "/github", afterResponse: { res async throws in
				#expect(res.status != .notFound)
			})
        }
    }

    @Test("Google Route")
    func googleRoute() async throws {
        try await withApp { app in
            try await app.test(.GET, "/google", afterResponse: { res async throws in
				#expect(res.status == .notFound)
			})

            try app.oAuth(from: Google.self, authenticate: "google", callback: "google-auth-complete", redirect: "/")

            try await app.test(.GET, "/google", afterResponse: { res async throws in
				#expect(res.status != .notFound)
			})
        }
    }

    @Test("Facebook Route")
    func facebookRoute() async throws {
        try await withApp { app in
            try await app.test(.GET, "/facebook", afterResponse: { res async throws in
                #expect(res.status == .notFound)
            })

            try app.oAuth(from: Facebook.self, authenticate: "facebook", callback: "facebook-auth-complete", redirect: "/")

            try await app.test(.GET, "/facebook", afterResponse: { res async throws in
                #expect(res.status != .notFound)
            })
        }
    }

    @Test("Keycloak Route")
    func keycloakRoute() async throws {
        try await withApp { app in
            try await app.test(.GET, "/keycloak", afterResponse: { res async throws in
                #expect(res.status == .notFound)
            })

            try app.oAuth(from: Keycloak.self, authenticate: "keycloak", callback: "keycloak-auth-complete", redirect: "/")

            try await app.test(.GET, "/keycloak", afterResponse: { res async throws in
                #expect(res.status != .notFound)
            })
        }
    }

    @Test("Discord Route")
    func discordRoute() async throws {
        try await withApp { app in
            try await app.test(.GET, "/discord", afterResponse: { res async throws in
                #expect(res.status == .notFound)
            })

            try app.oAuth(from: Discord.self, authenticate: "discord", callback: "discord-auth-complete", redirect: "/")

            try await app.test(.GET, "/discord", afterResponse: { res async throws in
                #expect(res.status != .notFound)
            })
        }
    }

    @Test("Auth0 Route")
    func auth0Route() async throws {
        try await withApp { app in
            try await app.test(.GET, "/auth0", afterResponse: { res async throws in
                #expect(res.status == .notFound)
            })

            try app.oAuth(from: Auth0.self, authenticate: "auth0", callback: "auth0-auth-complete", redirect: "/")

            try await app.test(.GET, "/auth0", afterResponse: { res async throws in
                #expect(res.status != .notFound)
            })
        }
    }
}
