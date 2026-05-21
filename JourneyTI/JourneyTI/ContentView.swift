import SwiftUI

struct ContentView: View {
    let onLogout: () -> Void

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")

            Button("Cerrar sesión") {
                onLogout()
            }
            .foregroundStyle(.red)
            .font(.system(size: 15, weight: .medium))
            .padding(.top, 32)
        }
        .padding()
    }
}

#Preview {
    ContentView(onLogout: {})
}
