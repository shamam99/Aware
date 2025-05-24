//
//  AudioListenerService.swift
//  HeadphonesAware
//
//  Created by Shamam Alkafri on 23/05/2025.
//

import Foundation
import AVFoundation
import Combine
import UserNotifications
import Speech

class AudioListenerService: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let request = SFSpeechAudioBufferRecognitionRequest()

    private var recognitionTask: SFSpeechRecognitionTask?
    private var cancellables = Set<AnyCancellable>()

    var keywords: [String] = []
    var alertOptions: (vibration: Bool, notification: Bool, pauseMusic: Bool) = (false, false, false)

    func startListening(keywords: [String], options: (Bool, Bool, Bool)) {
        self.keywords = keywords
        self.alertOptions = options

        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        } catch {
            print("❌ Failed to set audio session category: \(error.localizedDescription)")
            return
        }

        do {
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("❌ Failed to activate audio session: \(error.localizedDescription)")
            print("📌 Make sure no other app is using the microphone and your app is in foreground.")
            return
        }

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        if audioEngine.isRunning {
            audioEngine.stop()
            inputNode.removeTap(onBus: 0)
        }

        guard recordingFormat.sampleRate > 0 && recordingFormat.channelCount > 0 else {
            print("❌ Invalid input format: \(recordingFormat)")
            return
        }

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }

        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("❌ Failed to start audio engine: \(error.localizedDescription)")
            return
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
            if let error = error {
                print("❌ Recognition error: \(error.localizedDescription)")
                return
            }

            guard let result = result else { return }

            let spoken = result.bestTranscription.formattedString.lowercased()
            for keyword in self.keywords.map({ $0.lowercased() }) {
                if spoken.contains(keyword) {
                    self.triggerAlerts()
                    self.stopListening()
                    break
                }
            }
        }
    }

    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
    }

    private func triggerAlerts() {
        if alertOptions.vibration {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }

        if alertOptions.notification {
            let content = UNMutableNotificationContent()
            content.title = "Someone said your keyword!"
            content.body = "Your keyword was detected while using headphones."
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }

        if alertOptions.pauseMusic {
            try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        }
    }
}
