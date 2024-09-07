//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import AVFoundation

/// A singleton class responsible for managing audio playback throughout the app.
/// This class provides methods to play both system and custom sounds based on user preferences
/// stored in `UserDefaults`. The audio settings include enabling or disabling audio effects
/// and logging for debug purposes.
internal final class AudioManager {
    
    /// The shared instance of `AudioManager` for app-wide use.
    internal static let shared = AudioManager()
    
    /// A private property that tracks whether audio effects are enabled app-wide,
    /// managed with thread safety.
    private var _appWideEnabled: Bool {
        didSet { log("Audio settings changed: appWideEnabled is now \(_appWideEnabled)") }
    }
    
    /// A private queue used to synchronize access to `_appWideEnabled` to ensure thread safety.
    private let settingsQueue = DispatchQueue(label: "com.markbattistella.audioManager")
    
    /// The current audio settings object, which determines if audio effects and logging are
    /// enabled.
    private var settings: AudioSettings
    
    /// A public read-only property indicating whether audio effects are enabled app-wide.
    /// This value is accessed through a synchronized queue to ensure thread safety.
    internal var appWideEnabled: Bool {
        settingsQueue.sync {
            _appWideEnabled
        }
    }
    
    /// Private initializer for singleton use.
    /// Sets the default audio settings and initializes the observer for `UserDefaults` changes.
    private init() {
        self.settings = UserDefaultsAudioSettings(
            audioEnabledKey: AudioUserDefaultKeys.audioEffectsEnabled,
            loggingEnabledKey: AudioUserDefaultKeys.audioLoggingEnabled
        )
        self._appWideEnabled = settings.isEnabled
        observeUserDefaultsChanges()
    }
}

// MARK: - Setup methods

extension AudioManager {
    
    /// Sets up an observer to listen for changes in `UserDefaults` that affect the app's audio
    /// settings. Updates the `_appWideEnabled` property when changes are detected.
    private func observeUserDefaultsChanges() {
        NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification, object: nil, queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            self.settingsQueue.async {
                self._appWideEnabled = self.settings.isEnabled
            }
        }
    }
    
    /// Method to set a custom `AudioSettings` for testing or other purposes.
    /// - Parameter customSettings: An object conforming to `AudioSettings` protocol
    ///   that allows customization of audio settings like enabling/disabling effects and logging.
    internal func setCustomSettings(_ customSettings: AudioSettings) {
        settingsQueue.sync {
            self.settings = customSettings
            self._appWideEnabled = customSettings.isEnabled
        }
    }
}

// MARK: - Playback methods

extension AudioManager {
    
    /// Plays a system sound if app-wide audio effects are enabled.
    /// - Parameter sound: The `SystemSound` to be played.
    internal func play(_ sound: SystemSound) {
        guard appWideEnabled else {
            log("Playback aborted: Audio effects are disabled.")
            return
        }
        let baseUrl = "/System/Library/Audio/UISounds/"
        guard let url = URL(string: baseUrl + sound.rawValue) else {
            log("Error: Invalid URL for system sound: \(sound.rawValue)")
            return
        }
        playSound(url: url)
    }
    
    /// Plays a custom sound if app-wide audio effects are enabled.
    /// - Parameter sound: The `SoundRepresentable` custom sound to be played.
    internal func play(_ sound: SoundRepresentable) {
        guard appWideEnabled else {
            log("Playback aborted: Audio effects are disabled.")
            return
        }
        playSoundFile(name: sound.soundFile.name, extension: sound.soundFile.extension.rawValue)
    }
    
    /// Plays an audio file from a given URL.
    /// - Parameter url: The URL of the audio file to play.
    /// Logs errors if the sound ID cannot be created or if the URL is invalid.
    private func playSound(url: URL) {
        var soundID: SystemSoundID = 0
        let status = AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
        if status != kAudioServicesNoError {
            log("Error: Unable to create sound ID for URL: \(url)")
            return
        }
        AudioServicesPlaySystemSound(soundID)
        // Dispose of the sound ID after playback to manage resources
        AudioServicesDisposeSystemSoundID(soundID)
    }
    
    /// Plays an audio file located within the app bundle.
    /// - Parameters:
    ///   - name: The name of the audio file.
    ///   - ext: The file extension of the audio file.
    /// Logs an error if the file cannot be found or played.
    private func playSoundFile(name: String, extension ext: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            log("Error: Unable to find audio file with name: \(name).\(ext)")
            return
        }
        playSound(url: url)
    }
}

// MARK: - Helper methods

extension AudioManager {
    
    /// Logs messages based on the logging setting.
    /// - Parameter message: The message to log.
    /// Only logs messages if logging is enabled in the settings.
    private func log(_ message: String) {
        if settings.isLoggingEnabled {
            print(message)
        }
    }
}

// MARK: - Audio Playback Actions

#if os(iOS)

/// Plays a system sound through the shared `AudioManager` instance.
/// - Parameter sound: The `SystemSound` to be played.
public func play(_ sound: SystemSound) {
    AudioManager.shared.play(sound)
}

#endif

/// Plays a custom sound through the shared `AudioManager` instance.
/// - Parameter sound: The `SoundRepresentable` custom sound to be played.
public func play(_ sound: SoundRepresentable) {
    AudioManager.shared.play(sound)
}

