import Foundation

@Observable
final class SplashViewModel {
    private(set) var isActive = true

    func start() {
        Task {
            try? await Task.sleep(for: .seconds(2))
            isActive = false
        }
    }
}
