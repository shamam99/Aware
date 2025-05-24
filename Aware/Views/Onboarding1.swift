//
//  OnboardingView.swift
//  HeadphonesAware
//
//  Created by Shamam Alkafri on 23/05/2025.
//


import SwiftUI

struct OnboardingPage {
    let title: String
    let subtitle: String
    let imageName: String
    let isLast: Bool
}

struct Onboarding: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    @State private var navigateToMain = false

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to Aware",
            subtitle: "Stay present even with your headphones on.",
            imageName: "onBoarding1",
            isLast: false
        ),
        OnboardingPage(
            title: "Pick a name to listen for",
            subtitle: "We’ll notify you when someone says it.",
            imageName: "onBoarding2",
            isLast: false
        ),
        OnboardingPage(
            title: "Get alerts your way",
            subtitle: "Choose vibration, a notification, music pause or all three.",
            imageName: "onBoarding3",
            isLast: true
        )
    ]

    var body: some View {
        if navigateToMain {
            MainView()
        } else {
            VStack {
                Spacer()

                Text(pages[currentPage].title)
                    .font(.custom("SF Pro Rounded", size: 36))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("MainTextColor"))
                    .padding(.horizontal, 32)
                    .padding(.top, 24)

                Text(pages[currentPage].subtitle)
                    .font(.custom("SF Pro Rounded", size: 18))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.top, 8)

                Spacer()

                Image(pages[currentPage].imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 450)

                Spacer()

                HStack {
                    if !pages[currentPage].isLast {
                        Button("Skip") {
                            hasSeenOnboarding = true
                            navigateToMain = true
                        }
                        .font(.custom("SF Pro Rounded", size: 18))
                        .foregroundColor(.gray)

                        Spacer()

                        Button(action: {
                            currentPage += 1
                        }) {
                            Text("Next")
                                .font(.custom("SF Pro Rounded", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 12)
                                .background(Color("ButtonsColor"))
                                .cornerRadius(12)
                        }
                    } else {
                        Spacer()
                        Button(action: {
                            hasSeenOnboarding = true
                            navigateToMain = true
                        }) {
                            Text("Start")
                                .font(.custom("SF Pro Rounded", size: 16))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 140)
                                .padding(.vertical, 14)
                                .background(Color("ButtonsColor"))
                                .cornerRadius(12)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
            .transition(.slide)
            .animation(.easeInOut, value: currentPage)
            // Onboarding.swift
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "hasRequestedPermissions") {
                    PermissionManager.shared.requestAllPermissions { granted in
                        print("Permissions granted: \(granted)")
                        UserDefaults.standard.set(true, forKey: "hasRequestedPermissions")
                    }
                }
            }

        }
    }
}

#Preview {
    Onboarding()
}
