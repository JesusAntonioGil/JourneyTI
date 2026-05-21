import SwiftUI

struct ContentView: View {
    let onLogout: () -> Void
    let analyticsService: any AnalyticsService

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")

            Button("Cerrar sesión") {
                analyticsService.track(.action(.content, .logout))
                onLogout()
            }
            .foregroundStyle(.red)
            .font(.system(size: 15, weight: .medium))
            .padding(.top, 32)
        }
        .padding()
        .onAppear { analyticsService.track(.view(.content)) }
    }
}

#Preview {
    ContentView(onLogout: {}, analyticsService: NoOpAnalyticsService())
}
