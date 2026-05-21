import Foundation

@Observable
final class ForgotPasswordViewModel {
    var email = ""
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var isEmailSent = false

    private let useCase: ResetPasswordUseCase
    private let analyticsService: any AnalyticsService

    init(useCase: ResetPasswordUseCase, analyticsService: any AnalyticsService) {
        self.useCase = useCase
        self.analyticsService = analyticsService
    }

    var isSendEnabled: Bool {
        guard let atIndex = email.firstIndex(of: "@") else { return false }
        let afterAt = email[email.index(after: atIndex)...]
        return afterAt.contains(".")
    }

    func onViewAppear() {
        analyticsService.track(.view(.forgotPassword))
    }

    func onSubmitTapped() {
        analyticsService.track(.action(.forgotPassword, .submitResetPassword))
    }

    func sendReset() async {
        isLoading = true
        errorMessage = nil
        do {
            try await useCase.execute(email: email)
            analyticsService.track(.request(.resetPassword, .success))
            isEmailSent = true
            isLoading = false
        } catch {
            let code = (error as? AuthError)?.analyticsCode ?? "unknown"
            analyticsService.track(.request(.resetPassword, .failure(errorCode: code)))
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
