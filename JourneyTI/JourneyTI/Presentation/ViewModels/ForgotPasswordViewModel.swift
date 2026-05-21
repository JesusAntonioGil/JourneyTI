import Foundation

@Observable
final class ForgotPasswordViewModel {
    var email = ""
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var isEmailSent = false

    private let useCase: ResetPasswordUseCase

    init(useCase: ResetPasswordUseCase) {
        self.useCase = useCase
    }

    var isSendEnabled: Bool {
        guard let atIndex = email.firstIndex(of: "@") else { return false }
        let afterAt = email[email.index(after: atIndex)...]
        return afterAt.contains(".")
    }

    func sendReset() async {
        isLoading = true
        errorMessage = nil
        do {
            try await useCase.execute(email: email)
            isEmailSent = true
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
