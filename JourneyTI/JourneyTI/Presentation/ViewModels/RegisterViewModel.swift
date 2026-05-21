import Foundation

@Observable
final class RegisterViewModel {
    var email = ""
    var password = ""
    var confirmPassword = ""
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let useCase: RegisterUseCase
    private let onSuccess: () -> Void

    init(useCase: RegisterUseCase, onSuccess: @escaping () -> Void) {
        self.useCase = useCase
        self.onSuccess = onSuccess
    }

    var isRegisterEnabled: Bool {
        guard let atIndex = email.firstIndex(of: "@") else { return false }
        let afterAt = email[email.index(after: atIndex)...]
        return afterAt.contains(".") && password.count >= 6 && password == confirmPassword
    }

    func register() async {
        isLoading = true
        errorMessage = nil
        do {
            _ = try await useCase.execute(email: email, password: password)
            isLoading = false
            onSuccess()
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
