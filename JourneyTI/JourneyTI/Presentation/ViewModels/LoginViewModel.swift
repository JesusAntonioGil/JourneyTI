import Foundation

@Observable
final class LoginViewModel {
    var email = ""
    var password = ""
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let useCase: LoginUseCase

    init(useCase: LoginUseCase) {
        self.useCase = useCase
    }

    var isLoginEnabled: Bool {
        guard let atIndex = email.firstIndex(of: "@") else { return false }
        let afterAt = email[email.index(after: atIndex)...]
        return afterAt.contains(".") && !password.isEmpty
    }

    private(set) var isAuthenticated = false

    func login() async {
        isLoading = true
        errorMessage = nil
        do {
            _ = try await useCase.execute(email: email, password: password)
            isAuthenticated = true
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    func markAuthenticated() {
        isAuthenticated = true
    }

    func checkSession() {
        if useCase.currentUser() != nil {
            isAuthenticated = true
        }
    }
}
