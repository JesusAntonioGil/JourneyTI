import Foundation
import Testing
@testable import JourneyTI

// MARK: - Stub

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

// MARK: - Suite

@Suite("LoginViewModel")
struct LoginViewModelTests {

    private func makeViewModel(result: Result<User, AuthError> = .success(.stub)) -> LoginViewModel {
        let repo = StubAuthRepository(result: result)
        let useCase = LoginUseCase(repository: repo)
        return LoginViewModel(useCase: useCase)
    }

    // MARK: isLoginEnabled

    @Test("isLoginEnabled is false when email is empty")
    func loginDisabledWithEmptyEmail() {
        let sut = makeViewModel()
        sut.email = ""
        sut.password = "secret"
        #expect(sut.isLoginEnabled == false)
    }

    @Test("isLoginEnabled is false when email has no @ symbol")
    func loginDisabledWithMalformedEmail() {
        let sut = makeViewModel()
        sut.email = "notanemail"
        sut.password = "secret"
        #expect(sut.isLoginEnabled == false)
    }

    @Test("isLoginEnabled is true when email is valid and password is non-empty")
    func loginEnabledWithValidCredentials() {
        let sut = makeViewModel()
        sut.email = "user@example.com"
        sut.password = "secret"
        #expect(sut.isLoginEnabled == true)
    }

    // MARK: isLoading

    @Test("isLoading is true while login is in progress")
    func isLoadingDuringLogin() async throws {
        let sut = makeViewModel()
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
        let sut = makeViewModel(result: .failure(.invalidCredentials))
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
        let sut = makeViewModel(result: .success(expectedUser))
        sut.email = "user@example.com"
        sut.password = "secret"

        await sut.login()

        #expect(sut.errorMessage == nil)
        #expect(sut.isLoading == false)
    }
}

// MARK: - Test helpers

private extension User {
    static let stub = User(id: "1", email: "user@example.com", name: "Test User")
}
