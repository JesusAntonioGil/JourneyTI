import Testing
@testable import JourneyTI

@Suite("AnalyticsEvent")
struct AnalyticsEventTests {

    @Test("VIEW event tiene nombre VIEW y parámetro screen")
    func viewEventParameters() {
        let event = AnalyticsEvent.view(.login)
        #expect(event.name == "VIEW")
        #expect(event.parameters == ["screen": "login"])
    }

    @Test("ACTION event tiene nombre ACTION y parámetros screen y element")
    func actionEventParameters() {
        let event = AnalyticsEvent.action(.login, .loginButton)
        #expect(event.name == "ACTION")
        #expect(event.parameters == ["screen": "login", "element": "login_button"])
    }

    @Test("REQUEST success tiene resultado success sin error_code")
    func requestSuccessParameters() {
        let event = AnalyticsEvent.request(.login, .success)
        #expect(event.name == "REQUEST")
        #expect(event.parameters["name"] == "login")
        #expect(event.parameters["result"] == "success")
        #expect(event.parameters["error_code"] == nil)
    }

    @Test("REQUEST failure incluye result failure y error_code")
    func requestFailureParameters() {
        let event = AnalyticsEvent.request(.login, .failure(errorCode: "invalid_credentials"))
        #expect(event.name == "REQUEST")
        #expect(event.parameters["name"] == "login")
        #expect(event.parameters["result"] == "failure")
        #expect(event.parameters["error_code"] == "invalid_credentials")
    }

    @Test("Screen raw values son correctos")
    func screenRawValues() {
        #expect(Screen.login.rawValue == "login")
        #expect(Screen.forgotPassword.rawValue == "forgot_password")
        #expect(Screen.content.rawValue == "content")
    }

    @Test("RequestName raw values son correctos")
    func requestNameRawValues() {
        #expect(RequestName.resetPassword.rawValue == "reset_password")
        #expect(RequestName.logout.rawValue == "logout")
    }
}
