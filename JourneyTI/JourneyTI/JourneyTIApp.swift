//
//  JourneyTIApp.swift
//  JourneyTI
//
//  Created by Jesus Antonio Gil on 15/5/26.
//

import SwiftUI

@main
struct JourneyTIApp: App {
    @State private var splashViewModel = SplashViewModel()

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
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
