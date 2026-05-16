import SwiftUI

private extension Color {
    static let loginForeground = Color(red: 17 / 255, green: 24 / 255, blue: 39 / 255)
    static let loginAccent = Color(red: 22 / 255, green: 163 / 255, blue: 74 / 255)
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    header
                        .padding(.top, 80)
                        .padding(.bottom, 48)

                    form
                        .padding(.bottom, 32)

                    actions
                }
                .padding(.horizontal, 32)
            }
            .scrollBounceBehavior(.basedOnSize)
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

    private var form: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .accessibilityLabel("Dirección de email")

            SecureField("Contraseña", text: $password)
                .textContentType(.password)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .accessibilityLabel("Contraseña")
        }
    }

    private var actions: some View {
        VStack(spacing: 16) {
            Button("Iniciar sesión") {}
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.loginAccent)
                .foregroundStyle(.white)
                .font(.system(size: 16, weight: .semibold))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Button("¿No tienes cuenta? Regístrate") {}
                .foregroundStyle(Color.loginAccent)
                .font(.system(size: 15, weight: .medium))
        }
    }
}

#Preview {
    LoginView()
}
