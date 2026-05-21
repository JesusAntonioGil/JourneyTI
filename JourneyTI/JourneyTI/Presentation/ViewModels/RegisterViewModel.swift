import Foundation

@Observable
final class RegisterViewModel {
    var email = ""
    var password = ""
    var confirmPassword = ""
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let useCase: RegisterUseCase
    private let analyticsService: any AnalyticsService
    private let onSuccess: () -> Void

    init(useCase: RegisterUseCase, analyticsService: any AnalyticsService, onSuccess: @escaping () -> Void) {
        self.useCase = useCase
        self.analyticsService = analyticsService
        self.onSuccess = onSuccess
    }

    var isRegisterEnabled: Bool {
        guard let atIndex = email.firstIndex(of: "@") else { return false }
        let afterAt = email[email.index(after: atIndex)...]
        return afterAt.contains(".") && password.count >= 6 && password == confirmPassword
    }

    func onViewAppear() {
        analyticsService.track(.view(.register))
    }

    func onSubmitTapped() {
        analyticsService.track(.action(.register, .submitRegister))
    }

    func register() async {
        isLoading = true
        errorMessage = nil
        do {
            let user = try await useCase.execute(email: email, password: password)
            analyticsService.setUserId(user.id)
            analyticsService.setUserProperty("email_password", forName: "auth_provider")
            analyticsService.track(.request(.register, .success))
            isLoading = false
            onSuccess()
        } catch {
            let code = (error as? AuthError)?.analyticsCode ?? "unknown"
            analyticsService.track(.request(.register, .failure(errorCode: code)))
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
