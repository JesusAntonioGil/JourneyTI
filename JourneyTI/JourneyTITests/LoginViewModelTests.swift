import Foundation
import Testing
@testable import JourneyTI

// MARK: - Stubs / Spies

private final class StubAuthRepository: AuthRepository, @unchecked Sendable {
    var result: Result<User, AuthError>

    init(result: Result<User, AuthError>) {
        self.result = result
    }

    func login(email: String, password: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(50))
        switch result {
        case .success(let user): return user
        case .failure(let error): throw error
        }
    }

    func register(email: String, password: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(50))
        return User(id: "stub", email: email, name: "")
    }

    func resetPassword(email: String) async throws {}

    func currentUser() -> User? { nil }

    func logout() throws {}
}

private final class SpyAnalyticsService: AnalyticsService, @unchecked Sendable {
    private(set) var trackedEvents: [AnalyticsEvent] = []
    private(set) var userIdCalls: [String?] = []

    func track(_ event: AnalyticsEvent) { trackedEvents.append(event) }
    func setUserId(_ id: String?) { userIdCalls.append(id) }
    func setUserProperty(_ value: String?, forName name: String) {}
}

// MARK: - Suite

@Suite("LoginViewModel")
@MainActor
struct LoginViewModelTests {

    private func makeViewModel(
        result: Result<User, AuthError> = .success(.stub),
        spy: SpyAnalyticsService = SpyAnalyticsService()
    ) -> (LoginViewModel, SpyAnalyticsService) {
        let repo = StubAuthRepository(result: result)
        let useCase = LoginUseCase(repository: repo)
        return (LoginViewModel(useCase: useCase, analyticsService: spy), spy)
    }

    // MARK: isLoginEnabled

    @Test("isLoginEnabled is false when email is empty")
    func loginDisabledWithEmptyEmail() {
        let (sut, _) = makeViewModel()
        sut.email = ""
        sut.password = "secret"
        #expect(sut.isLoginEnabled == false)
    }

    @Test("isLoginEnabled is false when email has no @ symbol")
    func loginDisabledWithMalformedEmail() {
        let (sut, _) = makeViewModel()
        sut.email = "notanemail"
        sut.password = "secret"
        #expect(sut.isLoginEnabled == false)
    }

    @Test("isLoginEnabled is true when email is valid and password is non-empty")
    func loginEnabledWithValidCredentials() {
        let (sut, _) = makeViewModel()
        sut.email = "user@example.com"
        sut.password = "secret"
        #expect(sut.isLoginEnabled == true)
    }

    // MARK: isLoading

    @Test("isLoading is true while login is in progress")
    func isLoadingDuringLogin() async throws {
        let (sut, _) = makeViewModel()
        sut.email = "user@example.com"
        sut.password = "secret"

        let task = Task { await sut.login() }
        await Task.yield()
        #expect(sut.isLoading == true)
        await task.value
    }

    // MARK: errorMessage

    @Test("errorMessage contains localised description after invalid credentials")
    func errorMessageOnInvalidCredentials() async {
        let (sut, _) = makeViewModel(result: .failure(.invalidCredentials))
        sut.email = "user@example.com"
        sut.password = "wrong"

        await sut.login()

        let message = sut.errorMessage
        let expected = AuthError.invalidCredentials.localizedDescription
        #expect(message == expected)
    }

    @Test("errorMessage is nil and login succeeds after valid credentials")
    func noErrorMessageOnSuccess() async throws {
        let expectedUser = User.stub
        let (sut, _) = makeViewModel(result: .success(expectedUser))
        sut.email = "user@example.com"
        sut.password = "secret"

        await sut.login()

        #expect(sut.errorMessage == nil)
        #expect(sut.isLoading == false)
    }

    // MARK: Analytics

    @Test("onViewAppear registra evento VIEW login")
    func viewAppearTracksViewEvent() {
        let (sut, spy) = makeViewModel()
        sut.onViewAppear()
        #expect(spy.trackedEvents.first?.name == "VIEW")
        #expect(spy.trackedEvents.first?.parameters == ["screen": "login"])
    }

    @Test("onLoginTapped registra evento ACTION login_button")
    func loginTappedTracksActionEvent() {
        let (sut, spy) = makeViewModel()
        sut.onLoginTapped()
        #expect(spy.trackedEvents.first?.name == "ACTION")
        #expect(spy.trackedEvents.first?.parameters["element"] == "login_button")
    }

    @Test("login exitoso registra REQUEST login success y guarda userId")
    func loginSuccessTracksRequestEvent() async {
        let (sut, spy) = makeViewModel(result: .success(.stub))
        sut.email = "user@example.com"
        sut.password = "secret"
        await sut.login()
        let event = spy.trackedEvents.first { $0.name == "REQUEST" }
        #expect(event?.parameters["name"] == "login")
        #expect(event?.parameters["result"] == "success")
        #expect(spy.userIdCalls.contains("1"))
    }

    @Test("login fallido registra REQUEST login failure con error_code")
    func loginFailureTracksRequestEventWithErrorCode() async {
        let (sut, spy) = makeViewModel(result: .failure(.invalidCredentials))
        sut.email = "user@example.com"
        sut.password = "wrong"
        await sut.login()
        let event = spy.trackedEvents.first { $0.name == "REQUEST" }
        #expect(event?.parameters["name"] == "login")
        #expect(event?.parameters["result"] == "failure")
        #expect(event?.parameters["error_code"] == "invalid_credentials")
    }

    @Test("logout registra REQUEST logout success y limpia userId")
    func logoutTracksRequestEventAndClearsUserId() {
        let (sut, spy) = makeViewModel()
        sut.logout()
        let event = spy.trackedEvents.first { $0.name == "REQUEST" }
        #expect(event?.parameters["name"] == "logout")
        #expect(event?.parameters["result"] == "success")
        #expect(spy.userIdCalls.contains(nil))
    }
}

// MARK: - Test helpers

private extension User {
    static let stub = User(id: "1", email: "user@example.com", name: "Test User")
}
