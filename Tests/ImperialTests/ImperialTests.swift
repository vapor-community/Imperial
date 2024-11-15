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
}
