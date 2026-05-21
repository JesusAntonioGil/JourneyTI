import SwiftUI
import FirebaseCore

@main
struct JourneyTIApp: App {
    @State private var splashViewModel = SplashViewModel()
    @State private var loginViewModel: LoginViewModel

    init() {
        let hasConfig = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil
        if hasConfig { FirebaseApp.configure() }
        let repository: any AuthRepository = hasConfig ? FirebaseAuthRepository() : MockAuthRepository()
        _loginViewModel = State(
            initialValue: LoginViewModel(useCase: LoginUseCase(repository: repository))
        )
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                Group {
                    if loginViewModel.isAuthenticated {
                        ContentView(onLogout: { loginViewModel.logout() })
                    } else {
                        LoginView(viewModel: loginViewModel)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: loginViewModel.isAuthenticated)

                if splashViewModel.isActive {
                    SplashView()
                        .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.5), value: splashViewModel.isActive)
            .task {
                loginViewModel.checkSession()
                splashViewModel.start()
            }
        }
    }
}
