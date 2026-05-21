protocol AuthRepository {
    func login(email: String, password: String) async throws -> User
    func register(email: String, password: String) async throws -> User
    func resetPassword(email: String) async throws
    func currentUser() -> User?
}
