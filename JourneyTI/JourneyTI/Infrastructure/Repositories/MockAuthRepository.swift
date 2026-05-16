import Foundation

struct MockAuthRepository: AuthRepository {

    private let validEmail = "demo@journeyti.com"
    private let validPassword = "demo1234"

    func login(email: String, password: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(800))

        guard email == validEmail, password == validPassword else {
            throw AuthError.invalidCredentials
        }

        return User(
            id: "mock-user-001",
            email: validEmail,
            name: "Demo User"
        )
    }
}
