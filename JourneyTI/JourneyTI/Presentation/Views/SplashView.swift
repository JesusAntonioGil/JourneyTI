import SwiftUI

private extension Color {
    static let splashForeground = Color(red: 17 / 255, green: 24 / 255, blue: 39 / 255)
    static let splashAccent = Color(red: 22 / 255, green: 163 / 255, blue: 74 / 255)
}

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            Text("Journey\(Text("TI").foregroundStyle(Color.splashAccent))")
                .foregroundStyle(Color.splashForeground)
                .font(.system(size: 64, weight: .bold))
                .tracking(3)
                .accessibilityLabel("JourneyTI")
        }
    }
}

#Preview {
    SplashView()
}
