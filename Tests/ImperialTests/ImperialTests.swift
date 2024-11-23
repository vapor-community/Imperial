import ImperialAuth0
import ImperialDiscord
import ImperialDropbox
import ImperialFacebook
import ImperialGitHub
import ImperialGitlab
import ImperialGoogle
import ImperialKeycloak
import ImperialMicrosoft
import Testing
import XCTVapor

@testable import ImperialCore

@Suite("Imperial Tests")
struct ImperialTests {
    @Test("Auth0 Route")
    func auth0Route() async throws {
        try await withApp(service: Auth0.self) { app in
            try await app.test(
                .GET, "/service",
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "/service-auth-complete",
                afterResponse: { res async throws in
                    #expect(res.status != .notFound)
                }
            )
        }
    }

    @Test("Discord Route")
    func discordRoute() async throws {
        try await withApp(service: Discord.self) { app in
            try await app.test(
                .GET, "/service",
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "/service-auth-complete",
                afterResponse: { res async throws in
                    #expect(res.status != .notFound)
                }
            )
        }
    }

    @Test("Dropbox Route")
    func dropboxRoute() async throws {
        try await withApp(service: Dropbox.self) { app in
            try await app.test(
                .GET, "/service",
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "/service-auth-complete",
                afterResponse: { res async throws in
                    #expect(res.status != .notFound)
                }
            )
        }
    }

    @Test("Facebook Route")
    func facebookRoute() async throws {
        try await withApp(service: Facebook.self) { app in
            try await app.test(
                .GET, "/service",
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "/service-auth-complete",
                afterResponse: { res async throws in
                    #expect(res.status != .notFound)
                }
            )
        }
    }

    @Test("GitHub Route")
    func githubRoute() async throws {
        try await withApp(service: GitHub.self) { app in
            try await app.test(
                .GET, "/service",
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "/service-auth-complete",
                afterResponse: { res async throws in
                    #expect(res.status != .notFound)
                }
            )
        }
    }

    @Test("Gitlab Route")
    func gitlabRoute() async throws {
        try await withApp(service: Gitlab.self) { app in
            try await app.test(
                .GET, "/service",
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "/service-auth-complete",
                afterResponse: { res async throws in
                    #expect(res.status != .notFound)
                }
            )
        }
    }

    @Test("Google Route")
    func googleRoute() async throws {
        try await withApp(service: Google.self) { app in
            try await app.test(
                .GET, "/service",
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "/service-auth-complete",
                afterResponse: { res async throws in
                    #expect(res.status != .notFound)
                }
            )
        }
    }

    @Test("Google JWT Route")
    func googleJWTRoute() async throws {
        try await withApp(service: GoogleJWT.self) { app in
            try await app.test(
                .GET, "/service",
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "/service-auth-complete",
                afterResponse: { res async throws in
                    #expect(res.status != .notFound)
                }
            )
        }
    }

    @Test("Keycloak Route")
    func keycloakRoute() async throws {
        try await withApp(service: Keycloak.self) { app in
            try await app.test(
                .GET, "/service",
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "/service-auth-complete",
                afterResponse: { res async throws in
                    #expect(res.status != .notFound)
                }
            )
        }
    }

    @Test("Microsoft Route")
    func microsoftRoute() async throws {
        try await withApp(service: Microsoft.self) { app in
            try await app.test(
                .GET, "/service",
                afterResponse: { res async throws in
                    #expect(res.status == .seeOther)
                }
            )

            try await app.test(
                .GET, "/service-auth-complete",
                afterResponse: { res async throws in
                    #expect(res.status != .notFound)
                }
            )
        }
    }

    @Test("ImperialError & ServiceError")
    func errors() {
        let variable = "test"
        let imperialError = ImperialError.missingEnvVar(variable)
        #expect(
            imperialError.description
                == "ImperialError(errorType: \(imperialError.errorType.base.rawValue), missing enviroment variable: \(variable))"
        )
        #expect(ImperialError.missingEnvVar("foo") == ImperialError.missingEnvVar("bar"))

        let endpoint = "test"
        let serviceError = ServiceError.noServiceEndpoint(endpoint)
        #expect(
            serviceError.description
                == "ServiceError(errorType: \(serviceError.errorType.base.rawValue), service does not have available endpoint for key: \(endpoint))"
        )
        #expect(ServiceError.noServiceEndpoint("foo") == ServiceError.noServiceEndpoint("bar"))
    }
}
