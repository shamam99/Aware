//
//  AlertPreferencesView.swift
//  HeadphonesAware
//
//  Created by Shamam Alkafri on 23/05/2025.
//


import SwiftUI

struct AlertPreferencesView: View {
    @StateObject private var viewModel = AlertPreferencesViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - Back Button
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("ButtonsColor"))
                            .font(.system(size: 26, weight: .medium, design: .rounded))
                            .padding(.top, 10)
                    }
                    
                    Spacer()

                    // MARK: - Title & Description
                    Text("Set up your awareness")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color("MainTextColor"))

                    Text("Enter names or words you want to listen for.\nWe’ll alert you if someone says them.")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(.gray)

                    // MARK: - Keywords Input
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Keywords")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("MainTextColor"))

                        HStack(spacing: 14) {
                            TextField("+ Add Keywords", text: $viewModel.keywordInput)
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(viewModel.showKeywordLimitWarning ? Color.red : Color("ButtonsColor"), lineWidth: 1)
                                )
                                .foregroundColor(viewModel.showKeywordLimitWarning ? .red : .primary)

                            Button {
                                viewModel.addKeyword()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(viewModel.showKeywordLimitWarning ? .red : Color("ButtonsColor"))
                            }
                            .disabled(viewModel.keywordInput.isEmpty || viewModel.keywords.count >= 3)
                        }

                        WrapHStack(viewModel.keywords) { keyword in
                            HStack(spacing: 6) {
                                Text(keyword)
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.black)

                                Button(action: {
                                    viewModel.removeKeyword(keyword)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                        }

                        Text("You can add up to 3 names or words")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }

                    // MARK: - Alert Options
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Choose how you want to be alerted")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("MainTextColor"))

                        Text("You can choose one, two or all of them")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)

                        Toggle("Vibration", isOn: $viewModel.vibration)
                            .tint(Color("ButtonsColor"))
                            .font(.system(size: 18, design: .rounded))

                        Toggle("Notification", isOn: $viewModel.notification)
                            .tint(Color("ButtonsColor"))
                            .font(.system(size: 18, design: .rounded))

                        Toggle("Pause Music", isOn: $viewModel.pauseMusic)
                            .tint(Color("ButtonsColor"))
                            .font(.system(size: 18, design: .rounded))
                    }

                    // MARK: - Save Button
                    Button {
                        viewModel.savePreferences()
                    } label: {
                        Text("Save and Start Listening")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("ButtonsColor"))
                            .cornerRadius(12)
                    }
                    .padding(.top, 55)
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                .padding(.bottom, 40)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    AlertPreferencesView()
}
