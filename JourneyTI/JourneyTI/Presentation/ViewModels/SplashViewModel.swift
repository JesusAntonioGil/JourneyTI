import Foundation

@Observable
final class SplashViewModel {
    private(set) var isActive = true
    private let duration: Duration

    init(duration: Duration = .seconds(3)) {
        self.duration = duration
    }

    func start() {
        Task {
            try? await Task.sleep(for: duration)
            isActive = false
        }
    }
}
