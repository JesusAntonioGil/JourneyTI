import Foundation

final class ResetPasswordUseCase {
    private let repository: any AuthRepository

    init(repository: some AuthRepository) {
        self.repository = repository
    }

    func execute(email: String) async throws {
        try await repository.resetPassword(email: email)
    }
}
