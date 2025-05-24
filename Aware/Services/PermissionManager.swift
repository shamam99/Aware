//
//  PermissionManager.swift
//  HeadphonesAware
//
//  Created by Shamam Alkafri on 23/05/2025.
//

import Foundation
import AVFoundation
import UserNotifications

class PermissionManager {
    static let shared = PermissionManager()

    func requestAllPermissions(completion: @escaping (Bool) -> Void) {
        var micGranted = false
        var notifGranted = false

        let group = DispatchGroup()

        // Microphone
        group.enter()
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            micGranted = granted
            group.leave()
        }

        // Notifications
        group.enter()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            notifGranted = granted
            group.leave()
        }

        group.notify(queue: .main) {
            completion(micGranted && notifGranted)
        }
    }
}
