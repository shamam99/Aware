//
//  SwiftUIView.swift
//  HeadphonesAware
//
//  Created by Shamam Alkafri on 23/05/2025.
//


import SwiftUI

struct MainView: View {
    @State private var isListening = false
    @State private var animatePulse = false
    @State private var navigateToSetup = false
    @StateObject private var audioService = AudioListenerService()

    var body: some View {
        NavigationStack {
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // Hamburger Button
                VStack {
                    HStack {
                        Button(action: {
                            navigateToSetup = true
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.system(size: 32))
                                .foregroundColor(.white)
                                .padding(.leading, 24)
                                .padding(.top, 22)
                        }
                        Spacer()
                    }
                    Spacer()
                }

                // Listening Button + Animation
                GeometryReader { geo in
                    ZStack {
                        if isListening {
                            Circle()
                                .fill(Color(hex: "#39366C").opacity(0.5))
                                .frame(width: geo.size.width * 0.65)
                                .scaleEffect(animatePulse ? 1.1 : 0.95)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animatePulse)

                            Circle()
                                .fill(Color(hex: "#3C366D").opacity(0.4))
                                .frame(width: geo.size.width * 0.5)

                            Circle()
                                .fill(Color(hex: "#B8A8E1").opacity(0.76))
                                .frame(width: geo.size.width * 0.35)
                        } else {
                            Circle()
                                .fill(Color(hex: "#B8A8E1").opacity(0.3))
                                .frame(width: geo.size.width * 0.35)
                        }

                        Button(action: {
                            isListening.toggle()
                            if isListening {
                                audioService.startListening(
                                    keywords: UserDefaults.standard.stringArray(forKey: "savedKeywords") ?? [],
                                    options: (
                                        UserDefaults.standard.bool(forKey: "vibrationEnabled"),
                                        UserDefaults.standard.bool(forKey: "notificationEnabled"),
                                        UserDefaults.standard.bool(forKey: "pauseMusicEnabled")
                                    )
                                )
                            } else {
                                audioService.stopListening()
                            }
                        }) {
                            Text(isListening ? "Stop" : "Start")
                                .foregroundColor(Color("MainTextColor"))
                                .font(.custom("SF Pro Rounded", size: 22))
                                .fontWeight(.bold)
                                .frame(width: geo.size.width * 0.35, height: geo.size.width * 0.35)
                                .background(Color.clear)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                NavigationLink("", destination: AlertPreferencesView(), isActive: $navigateToSetup)
                    .hidden()
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                print("Has seen onboarding:", UserDefaults.standard.bool(forKey: "hasSeenOnboarding"))
                print("Keywords saved:", UserDefaults.standard.stringArray(forKey: "savedKeywords") ?? [])
                print("Notification enabled:", UserDefaults.standard.bool(forKey: "notificationEnabled"))
            }

        }
    }
}

#Preview {
    MainView()
}


// MARK: - Hex Color Extension
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}
