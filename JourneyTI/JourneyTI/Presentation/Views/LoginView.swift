import SwiftUI

private extension Color {
    static let loginForeground = Color(red: 17 / 255, green: 24 / 255, blue: 39 / 255)
    static let loginAccent = Color(red: 22 / 255, green: 163 / 255, blue: 74 / 255)
}

struct LoginView: View {
    private let loginViewModel: LoginViewModel
    private let registerUseCase: RegisterUseCase
    private let resetPasswordUseCase: ResetPasswordUseCase
    private let analyticsService: any AnalyticsService
    @State private var showRegister = false
    @State private var showForgotPassword = false

    init(
        viewModel: LoginViewModel,
        registerUseCase: RegisterUseCase,
        resetPasswordUseCase: ResetPasswordUseCase,
        analyticsService: any AnalyticsService
    ) {
        loginViewModel = viewModel
        self.registerUseCase = registerUseCase
        self.resetPasswordUseCase = resetPasswordUseCase
        self.analyticsService = analyticsService
    }

    var body: some View {
        @Bindable var viewModel = loginViewModel

        ZStack {
            Color.white
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    header
                        .padding(.top, 80)
                        .padding(.bottom, 48)

                    form(email: $viewModel.email, password: $viewModel.password)
                        .padding(.bottom, 8)

                    if let message = loginViewModel.errorMessage {
                        Text(message)
                            .foregroundStyle(.red)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 16)
                    }

                    actions
                        .padding(.bottom, 32)
                }
                .padding(.horizontal, 32)
            }
            .scrollBounceBehavior(.basedOnSize)

            if loginViewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.15)
                        .ignoresSafeArea()
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
        }
        .onAppear { loginViewModel.onViewAppear() }
        .animation(.easeInOut(duration: 0.2), value: loginViewModel.errorMessage)
        .animation(.easeInOut(duration: 0.2), value: loginViewModel.isLoading)
        .sheet(isPresented: $showRegister) {
            RegisterView(
                viewModel: RegisterViewModel(
                    useCase: registerUseCase,
                    analyticsService: analyticsService,
                    onSuccess: { loginViewModel.markAuthenticated() }
                )
            )
        }
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordView(
                viewModel: ForgotPasswordViewModel(
                    useCase: resetPasswordUseCase,
                    analyticsService: analyticsService
                )
            )
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("Journey\(Text("TI").foregroundStyle(Color.loginAccent))")
                .foregroundStyle(Color.loginForeground)
                .font(.system(size: 40, weight: .bold))
                .tracking(3)
                .accessibilityLabel("JourneyTI")

            Text("Inicia sesión para continuar")
                .foregroundStyle(.secondary)
                .font(.subheadline)
        }
    }

    private func form(email: Binding<String>, password: Binding<String>) -> some View {
        VStack(spacing: 16) {
            TextField("Email", text: email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .accessibilityLabel("Dirección de email")

            SecureField("Contraseña", text: password)
                .textContentType(.password)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .accessibilityLabel("Contraseña")
        }
    }

    private var actions: some View {
        VStack(spacing: 16) {
            Button("Iniciar sesión") {
                loginViewModel.onLoginTapped()
                Task { await loginViewModel.login() }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(loginViewModel.isLoginEnabled ? Color.loginAccent : Color(.systemGray4))
            .foregroundStyle(.white)
            .font(.system(size: 16, weight: .semibold))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .disabled(!loginViewModel.isLoginEnabled || loginViewModel.isLoading)

            Button("¿Olvidaste tu contraseña?") {
                loginViewModel.onForgotPasswordTapped()
                showForgotPassword = true
            }
            .foregroundStyle(Color.loginAccent)
            .font(.system(size: 15, weight: .medium))

            Button("¿No tienes cuenta? Regístrate") {
                loginViewModel.onRegisterTapped()
                showRegister = true
            }
            .foregroundStyle(Color.loginAccent)
            .font(.system(size: 15, weight: .medium))
        }
    }
}

#Preview {
    let repo = MockAuthRepository()
    LoginView(
        viewModel: LoginViewModel(useCase: LoginUseCase(repository: repo), analyticsService: NoOpAnalyticsService()),
        registerUseCase: RegisterUseCase(repository: repo),
        resetPasswordUseCase: ResetPasswordUseCase(repository: repo),
        analyticsService: NoOpAnalyticsService()
    )
}
