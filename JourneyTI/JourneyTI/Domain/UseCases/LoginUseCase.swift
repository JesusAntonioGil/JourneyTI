import Foundation

final class LoginUseCase {
    private let repository: any AuthRepository

    init(repository: some AuthRepository) {
        self.repository = repository
    }

    func execute(email: String, password: String) async throws -> User {
        return try await repository.login(email: email, password: password)
    }

    func currentUser() -> User? {
        repository.currentUser()
    }

    func logout() throws {
        try repository.logout()
    }
}
