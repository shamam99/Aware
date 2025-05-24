//
//  SplashView.swift
//  HeadphonesAware
//
//  Created by Shamam Alkafri on 23/05/2025.
//


import SwiftUI

// SplashView.swift
struct SplashView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var shouldNavigate = false

    var body: some View {
        Group {
            if shouldNavigate {
                if !hasSeenOnboarding {
                    Onboarding()
                } else {
                    MainView()
                }
            } else {
                ZStack {
                    Color.white.ignoresSafeArea()
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        shouldNavigate = true
                    }
                }
            }
        }
    }
}


#Preview {
    SplashView()
}
