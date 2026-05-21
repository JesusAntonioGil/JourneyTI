import SwiftUI
import FirebaseCore

@main
struct JourneyTIApp: App {
    @State private var splashViewModel = SplashViewModel()
    @State private var loginViewModel: LoginViewModel

    init() {
        FirebaseApp.configure()
        _loginViewModel = State(
            initialValue: LoginViewModel(
                useCase: LoginUseCase(repository: FirebaseAuthRepository())
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                Group {
                    if loginViewModel.isAuthenticated {
                        ContentView()
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
            .task { splashViewModel.start() }
        }
    }
}
