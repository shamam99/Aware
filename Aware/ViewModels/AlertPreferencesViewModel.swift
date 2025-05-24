//
//  AlertPreferencesViewModel.swift
//  HeadphonesAware
//
//  Created by Shamam Alkafri on 23/05/2025.
//

import Foundation
import SwiftUI

class AlertPreferencesViewModel: ObservableObject {
    @Published var keywordInput: String = ""
    @Published var keywords: [String] = []

    @Published var vibration: Bool = false
    @Published var notification: Bool = false
    @Published var pauseMusic: Bool = false

    var showKeywordLimitWarning: Bool {
        return keywords.count >= 3 && !keywordInput.isEmpty
    }

    func addKeyword() {
        let trimmed = keywordInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty,
              !keywords.contains(trimmed),
              keywords.count < 3 else { return }
        keywords.append(trimmed)
        keywordInput = ""
    }

    func removeKeyword(_ keyword: String) {
        keywords.removeAll { $0 == keyword }
    }

    func savePreferences() {
        print("Saved → keywords: \(keywords)")
        print("Vibration: \(vibration), Notification: \(notification), PauseMusic: \(pauseMusic)")
        UserDefaults.standard.set(keywords, forKey: "savedKeywords")
        UserDefaults.standard.set(vibration, forKey: "vibrationEnabled")
        UserDefaults.standard.set(notification, forKey: "notificationEnabled")
        UserDefaults.standard.set(pauseMusic, forKey: "pauseMusicEnabled")
    }
}
