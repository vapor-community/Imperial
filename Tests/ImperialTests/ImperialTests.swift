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

    @Test("Dropbox Route")
    func dropboxRoute() async throws {
        try await withApp { app in
            try await app.test(.GET, "/dropbox", afterResponse: { res async throws in
                #expect(res.status == .notFound)
            })

            try app.oAuth(from: Dropbox.self, authenticate: "dropbox", callback: "dropbox-auth-complete", redirect: "/")

            try await app.test(.GET, "/dropbox", afterResponse: { res async throws in
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

    @Test("Gitlab Route")
    func gitlabRoute() async throws {
        try await withApp { app in
            try await app.test(.GET, "/gitlab", afterResponse: { res async throws in
                #expect(res.status == .notFound)
            })

            try app.oAuth(from: Gitlab.self, authenticate: "gitlab", callback: "gitlab-auth-complete", redirect: "/")

            try await app.test(.GET, "/gitlab", afterResponse: { res async throws in
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

    @Test("Google JWT Route")
    func googleJWTRoute() async throws {
        try await withApp { app in
            try await app.test(.GET, "/googleJWT", afterResponse: { res async throws in
                #expect(res.status == .notFound)
            })

            try app.oAuth(from: GoogleJWT.self, authenticate: "googleJWT", callback: "googleJWT-auth-complete", redirect: "/")

            try await app.test(.GET, "/googleJWT", afterResponse: { res async throws in
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

    @Test("Microsoft Route")
    func microsoftRoute() async throws {
        try await withApp { app in
            try await app.test(.GET, "/microsoft", afterResponse: { res async throws in
                #expect(res.status == .notFound)
            })

            try app.oAuth(from: Microsoft.self, authenticate: "microsoft", callback: "microsoft-auth-complete", redirect: "/")

            try await app.test(.GET, "/microsoft", afterResponse: { res async throws in
                #expect(res.status != .notFound)
            })
        }
    }

    @Test("ImperialError & ServiceError")
    func errors() {
        #expect(ImperialError.missingEnvVar("test").description == "ImperialError(errorType: missingEnvVar, missing enviroment variable: test)")
        #expect(ImperialError.missingEnvVar("foo") == ImperialError.missingEnvVar("bar"))

        #expect(ServiceError.noServiceEndpoint("test").description == "ServiceError(errorType: noServiceEndpoint, service does not have available endpoint for key: test)")
        #expect(ServiceError.noServiceEndpoint("foo") == ServiceError.noServiceEndpoint("bar"))
    }
}
