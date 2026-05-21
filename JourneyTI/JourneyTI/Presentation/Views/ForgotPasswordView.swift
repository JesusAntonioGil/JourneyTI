import SwiftUI

private extension Color {
    static let forgotForeground = Color(red: 17 / 255, green: 24 / 255, blue: 39 / 255)
    static let forgotAccent = Color(red: 22 / 255, green: 163 / 255, blue: 74 / 255)
}

struct ForgotPasswordView: View {
    private let viewModel: ForgotPasswordViewModel
    @Environment(\.dismiss) private var dismiss

    init(viewModel: ForgotPasswordViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        @Bindable var model = viewModel

        ZStack {
            Color.white
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    header
                        .padding(.top, 80)
                        .padding(.bottom, 48)

                    if viewModel.isEmailSent {
                        successMessage
                            .padding(.bottom, 32)
                    } else {
                        emailField(email: $model.email)
                            .padding(.bottom, 8)

                        if let message = viewModel.errorMessage {
                            Text(message)
                                .foregroundStyle(.red)
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 16)
                        }

                        sendButton
                            .padding(.bottom, 32)
                    }
                }
                .padding(.horizontal, 32)
            }
            .scrollBounceBehavior(.basedOnSize)

            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.15)
                        .ignoresSafeArea()
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
        }
        .onAppear { viewModel.onViewAppear() }
        .animation(.easeInOut(duration: 0.2), value: viewModel.errorMessage)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)
        .animation(.easeInOut(duration: 0.3), value: viewModel.isEmailSent)
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("Journey\(Text("TI").foregroundStyle(Color.forgotAccent))")
                .foregroundStyle(Color.forgotForeground)
                .font(.system(size: 40, weight: .bold))
                .tracking(3)
                .accessibilityLabel("JourneyTI")

            Text("Recupera tu contraseña")
                .foregroundStyle(.secondary)
                .font(.subheadline)
        }
    }

    private func emailField(email: Binding<String>) -> some View {
        TextField("Email", text: email)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .accessibilityLabel("Dirección de email")
            .padding(.bottom, 8)
    }

    private var sendButton: some View {
        Button("Enviar enlace de recuperación") {
            viewModel.onSubmitTapped()
            Task { await viewModel.sendReset() }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(viewModel.isSendEnabled ? Color.forgotAccent : Color(.systemGray4))
        .foregroundStyle(.white)
        .font(.system(size: 16, weight: .semibold))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .disabled(!viewModel.isSendEnabled || viewModel.isLoading)
    }

    private var successMessage: some View {
        VStack(spacing: 16) {
            Image(systemName: "envelope.badge.checkmark")
                .font(.system(size: 48))
                .foregroundStyle(Color.forgotAccent)

            Text("Revisa tu email")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.forgotForeground)

            Text("Hemos enviado un enlace para restablecer tu contraseña a \(viewModel.email).")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Volver al inicio de sesión") {
                dismiss()
            }
            .foregroundStyle(Color.forgotAccent)
            .font(.system(size: 15, weight: .medium))
            .padding(.top, 8)
        }
    }
}

#Preview {
    ForgotPasswordView(
        viewModel: ForgotPasswordViewModel(
            useCase: ResetPasswordUseCase(repository: MockAuthRepository()),
            analyticsService: NoOpAnalyticsService()
        )
    )
}
