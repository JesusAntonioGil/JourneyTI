import Testing
@testable import JourneyTI

@Suite("SplashViewModel")
struct SplashViewModelTests {

    @Test("starts as active")
    func startsAsActive() {
        let viewModel = SplashViewModel()
        #expect(viewModel.isActive == true)
    }

    @Test("remains active before delay completes")
    func remainsActiveDuringDelay() {
        let viewModel = SplashViewModel(duration: .seconds(10))
        viewModel.start()
        #expect(viewModel.isActive == true)
    }

    @Test("becomes inactive after delay completes")
    func becomesInactiveAfterDelay() async throws {
        let viewModel = SplashViewModel(duration: .milliseconds(50))
        viewModel.start()
        try await Task.sleep(for: .milliseconds(200))
        #expect(viewModel.isActive == false)
    }
}
