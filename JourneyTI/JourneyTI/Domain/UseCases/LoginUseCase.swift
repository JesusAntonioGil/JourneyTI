import Foundation

final class LoginUseCase {
    private let repository: any AuthRepository

    init(repository: some AuthRepository) {
        self.repository = repository
    }

    func execute(email: String, password: String) async throws -> User {
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.invalidCredentials
        }
        return try await repository.login(email: email, password: password)
    }
}
