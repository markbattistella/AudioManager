//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import AVFoundation
import OSLog
import SimpleLogger

/// Extension to `LoggerCategory` to add a custom category for package audio management.
extension LoggerCategory {
    internal static let packageAudioManager = LoggerCategory("PackageAudioManager")
}

/// A singleton class responsible for managing audio playback throughout the app.
/// This class provides methods to play both system and custom sounds based on user preferences
/// stored in `UserDefaults`. The audio settings include enabling or disabling audio effects
/// and logging for debug purposes.
internal final class AudioManager {

    /// The shared instance of `AudioManager` for app-wide use.
    internal static let shared = AudioManager()

    /// Returns the shared defaults object.
    private let defaults = UserDefaults.standard

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
        settingsQueue.sync { _appWideEnabled }
    }

    /// A logger instance dedicated to audio to handle and filter log outputs.
    private let logger = Logger(category: .packageAudioManager)

    /// The count of log attempts, retrieved from UserDefaults.
    private var logAttemptCount: Int {
        get { defaults.integer(for: AudioUserDefaultKeys.audioLogAttemptCount) }
        set { defaults.set(newValue, for: AudioUserDefaultKeys.audioLogAttemptCount) }
    }

    /// The last time a log was made, retrieved from UserDefaults.
    private var lastLogTime: Date {
        get { defaults.date(for: AudioUserDefaultKeys.audioLogLastLogDate) ?? .now }
        set { defaults.set(newValue, for: AudioUserDefaultKeys.audioLogLastLogDate) }
    }

    /// The threshold for log attempts before logging again, retrieved from settings.
    private var logThreshold: Int {
        settings.loggingThreshold
    }

    /// The cooldown period in seconds before allowing another log, retrieved from settings.
    private var logCooldown: TimeInterval {
        settings.loggingCooldown
    }

    // MARK: - Initializers

    /// Private initializer for singleton use.
    /// Sets the default audio settings and initializes the observer for `UserDefaults` changes.
    private init() {
        self.settings = AudioUserDefaultsSettings(
            audioEnabledKey: AudioUserDefaultKeys.audioEffectsEnabled,
            audioLoggingEnabledKey: AudioUserDefaultKeys.audioLoggingEnabled,
            audioLoggingThresholdKey: AudioUserDefaultKeys.audioLogThreshold,
            audioLoggingCooldownKey: AudioUserDefaultKeys.audioLogCooldown
        )
        self._appWideEnabled = settings.isEnabled
        observeUserDefaultsChanges()
    }

    /// Deinitializes the `AudioManager`, removing any observers to prevent memory leaks.
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UserDefaults.didChangeNotification,
            object: nil
        )
    }
}

// MARK: - Setup methods

extension AudioManager {

    /// Sets up observation of changes to user defaults to update the `appWideEnabled` property.
    ///
    /// Observes `UserDefaults.didChangeNotification` on a background queue to respond to changes
    /// in user preferences for audio feedback.
    private func observeUserDefaultsChanges() {
        NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: OperationQueue()
        ) { [weak self] _ in
            self?.updateAppWideEnabled()
        }
    }

    /// Updates the `appWideEnabled` property based on the current settings in a thread-safe
    /// manner.
    ///
    /// This method ensures that changes to the audio settings are reflected immediately
    /// across the application when user preferences are updated.
    private func updateAppWideEnabled() {
        settingsQueue.async(flags: .barrier) {
            self._appWideEnabled = self.settings.isEnabled
            self.resetLogTrackingIfAudioEnabled()
        }
    }

    /// Sets custom audio settings for the manager, allowing for testing or alternative
    /// configurations.
    ///
    /// - Parameter customSettings: A custom implementation of `AudioSettings`.
    internal func setCustomSettings(_ customSettings: AudioSettings) {
        settingsQueue.async(flags: .barrier) {
            self.settings = customSettings
            self._appWideEnabled = customSettings.isEnabled
            self.resetLogTrackingIfAudioEnabled()
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

    /// Resets log tracking if audio are re-enabled to prevent unnecessary log suppression.
    private func resetLogTrackingIfAudioEnabled() {
        if _appWideEnabled {
            logAttemptCount = 0
            lastLogTime = Date()
        }
    }

    /// Logs messages for debugging purposes if logging is enabled, with suppression logic.
    ///
    /// - Parameter message: The message to be logged.
    private func log(_ message: String, logLimit: Int = Int.max) {
        logAttemptCount += 1
        let currentTime = Date()

        // Only log if below the limit for this app session
        guard logAttemptCount <= logLimit else { return }

        // Log only if the threshold is reached or cooldown period has passed
        if logAttemptCount >= logThreshold || currentTime.timeIntervalSince(lastLogTime) >= logCooldown {
            if settings.isLoggingEnabled {
                logger.log("\(message, privacy: .public)")
            }
            logAttemptCount = 0
            lastLogTime = currentTime
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
