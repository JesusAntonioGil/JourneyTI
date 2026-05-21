import FirebaseAuth

final class FirebaseAuthRepository: AuthRepository {
    func login(email: String, password: String) async throws -> User {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return User(
                id: result.user.uid,
                email: result.user.email ?? email,
                name: result.user.displayName ?? ""
            )
        } catch let err as NSError {
            throw AuthError(firebaseError: err)
        }
    }

    func register(email: String, password: String) async throws -> User {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            return User(
                id: result.user.uid,
                email: result.user.email ?? email,
                name: ""
            )
        } catch let err as NSError {
            throw AuthError(firebaseError: err)
        }
    }

    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch let err as NSError {
            throw AuthError(firebaseError: err)
        }
    }

    func currentUser() -> User? {
        guard let user = Auth.auth().currentUser else { return nil }
        return User(id: user.uid, email: user.email ?? "", name: user.displayName ?? "")
    }
}

private extension AuthError {
    init(firebaseError: NSError) {
        switch AuthErrorCode(rawValue: firebaseError.code) {
        case .wrongPassword, .invalidCredential:
            self = .invalidCredentials
        case .userNotFound:
            self = .userNotFound
        case .emailAlreadyInUse:
            self = .emailAlreadyInUse
        case .weakPassword:
            self = .weakPassword
        case .networkError:
            self = .networkUnavailable
        default:
            self = .unknown
        }
    }
}
