import Foundation

@Observable
final class LoginViewModel {
    var email = ""
    var password = ""
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let useCase: LoginUseCase
    private let analyticsService: any AnalyticsService

    init(useCase: LoginUseCase, analyticsService: any AnalyticsService) {
        self.useCase = useCase
        self.analyticsService = analyticsService
    }

    var isLoginEnabled: Bool {
        guard let atIndex = email.firstIndex(of: "@") else { return false }
        let afterAt = email[email.index(after: atIndex)...]
        return afterAt.contains(".") && !password.isEmpty
    }

    private(set) var isAuthenticated = false

    func onViewAppear() {
        analyticsService.track(.view(.login))
    }

    func onLoginTapped() {
        analyticsService.track(.action(.login, .loginButton))
    }

    func onForgotPasswordTapped() {
        analyticsService.track(.action(.login, .forgotPassword))
    }

    func onRegisterTapped() {
        analyticsService.track(.action(.login, .register))
    }

    func login() async {
        isLoading = true
        errorMessage = nil
        do {
            let user = try await useCase.execute(email: email, password: password)
            analyticsService.setUserId(user.id)
            analyticsService.setUserProperty("email_password", forName: "auth_provider")
            analyticsService.track(.request(.login, .success))
            isAuthenticated = true
            isLoading = false
        } catch {
            let code = (error as? AuthError)?.analyticsCode ?? "unknown"
            analyticsService.track(.request(.login, .failure(errorCode: code)))
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

    func logout() {
        analyticsService.track(.request(.logout, .success))
        analyticsService.setUserId(nil)
        try? useCase.logout()
        isAuthenticated = false
    }
}
