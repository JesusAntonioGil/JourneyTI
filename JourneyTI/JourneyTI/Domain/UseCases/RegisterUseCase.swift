import Foundation

final class RegisterUseCase {
    private let repository: any AuthRepository

    init(repository: some AuthRepository) {
        self.repository = repository
    }

    func execute(email: String, password: String) async throws -> User {
        return try await repository.register(email: email, password: password)
    }
}
