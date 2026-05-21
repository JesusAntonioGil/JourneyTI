import SwiftUI

private extension Color {
    static let registerForeground = Color(red: 17 / 255, green: 24 / 255, blue: 39 / 255)
    static let registerAccent = Color(red: 22 / 255, green: 163 / 255, blue: 74 / 255)
}

struct RegisterView: View {
    private let viewModel: RegisterViewModel
    @Environment(\.dismiss) private var dismiss

    init(viewModel: RegisterViewModel) {
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

                    form(email: $model.email, password: $model.password, confirm: $model.confirmPassword)
                        .padding(.bottom, 8)

                    if let message = viewModel.errorMessage {
                        Text(message)
                            .foregroundStyle(.red)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 16)
                    }

                    registerButton
                        .padding(.bottom, 32)
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
        .animation(.easeInOut(duration: 0.2), value: viewModel.errorMessage)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("Journey\(Text("TI").foregroundStyle(Color.registerAccent))")
                .foregroundStyle(Color.registerForeground)
                .font(.system(size: 40, weight: .bold))
                .tracking(3)
                .accessibilityLabel("JourneyTI")

            Text("Crea tu cuenta")
                .foregroundStyle(.secondary)
                .font(.subheadline)
        }
    }

    private func form(
        email: Binding<String>,
        password: Binding<String>,
        confirm: Binding<String>
    ) -> some View {
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
                .textContentType(.newPassword)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .accessibilityLabel("Contraseña")

            SecureField("Confirmar contraseña", text: confirm)
                .textContentType(.newPassword)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .accessibilityLabel("Confirmar contraseña")
        }
    }

    private var registerButton: some View {
        Button("Registrarse") {
            Task { await viewModel.register() }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(viewModel.isRegisterEnabled ? Color.registerAccent : Color(.systemGray4))
        .foregroundStyle(.white)
        .font(.system(size: 16, weight: .semibold))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .disabled(!viewModel.isRegisterEnabled || viewModel.isLoading)
    }
}

#Preview {
    RegisterView(
        viewModel: RegisterViewModel(
            useCase: RegisterUseCase(repository: MockAuthRepository()),
            onSuccess: {}
        )
    )
}
