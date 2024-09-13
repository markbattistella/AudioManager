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
///
/// This class provides methods to play both system and custom sounds based on user preferences
/// stored in `UserDefaults`. The audio settings include enabling or disabling audio effects
/// and logging for debug purposes. The `AudioManager` ensures thread safety when accessing
/// and modifying settings, and it integrates with a custom logger for detailed log output.
@MainActor
internal final class AudioManager {

    /// The shared instance of `AudioManager` for app-wide use.
    internal static let shared = AudioManager()

    /// Returns the shared defaults object.
    private let defaults = UserDefaults.standard

    /// A private property that tracks whether audio effects are enabled app-wide, managed with
    /// thread safety.
    private var _appWideEnabled: Bool

    /// The current audio settings object, which determines if audio effects and logging are
    /// enabled.
    private var settings: AudioSettings

    /// A logger instance dedicated to audio to handle and filter log outputs.
    private let logger = Logger(category: .packageAudioManager)

    /// A private queue used to synchronize access to settings to ensure thread safety.
    private let settingsQueue = DispatchQueue(
        label: "com.markbattistella.audioManager",
        attributes: .concurrent
    )

    /// Indicates whether audio feedback is enabled for the application, synchronized for
    /// thread safety.
    internal var appWideEnabled: Bool { settingsQueue.sync { _appWideEnabled } }

    /// Counter for logging occurrences in production mode.
    private var productionModeLogCount = 0

    /// Counter for logging occurrences of user defaults disabling audio.
    private var userDefaultsDisabledLogCount = 0

    /// The threshold for limiting log messages.
    private let logThreshold = 5

    /// The last time a log was printed.
    private var lastLogTime: Date?

    /// The last known state of app-wide audio enablement.
    private var lastAppWideEnabledState: Bool?

    /// The last known state of audio enablement.
    private var lastAudioEnabledState: Bool?

    /// The last known state of logging enablement.
    private var lastKnownLoggingState: Bool?

    /// The last time a "skip log" message was printed.
    private var lastSkipLogTime: Date?

    // MARK: - Initializers

    /// Initializes the `AudioManager` with default settings.
    ///
    /// This initializer sets up the manager with default `AudioUserDefaultsSettings` and begins
    /// observing changes to user defaults to update settings in real-time.
    private init() {
        self.settings = AudioUserDefaultsSettings(
            audioEnabledKey: AudioUserDefaultKeys.audioEffectsEnabled,
            audioLoggingEnabledKey: AudioUserDefaultKeys.audioLoggingEnabled
        )
        self._appWideEnabled = settings.isEnabled
        observeUserDefaultsChanges()
        self.logInitialStatus()
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
        ) { [self] _ in
            Task { @MainActor in
                self.updateAppWideEnabled()
                self.logAppWideStatusChange()
            }
        }
    }

    /// Updates the `appWideEnabled` property based on the current settings in a thread-safe
    /// manner.
    ///
    /// This method ensures that changes to the audio settings are reflected immediately
    /// across the application when user preferences are updated.
    private func updateAppWideEnabled() {
        _appWideEnabled = settings.isEnabled
    }
}

// MARK: - Logging Methods

extension AudioManager {

    /// Determines whether logging should occur based on the current settings and build configuration.
    ///
    /// - Returns: `true` if logging is enabled and the build is in debug mode; otherwise, `false`.
    private func shouldLog() -> Bool {
        #if DEBUG
        return settings.isLoggingEnabled
        #else
        return false
        #endif
    }
    
    /// Logs the initial status when the manager initializes.
    private func logInitialStatus() {
        guard shouldLog() else { return }
        logSettings(mode: .complete())
    }

    /// Logs changes in the app-wide enabled status.
    private func logAppWideStatusChange() {
        guard shouldLog() else { return }
        settingsQueue.sync {
            logger.info("App-wide enabled status changed: \(self._appWideEnabled)")
        }
    }

    /// Logs the current settings based on the specified logging mode.
    ///
    /// - Parameter mode: The mode in which to log settings, either `.smart` or `.complete`.
    internal func logSettings(mode: LoggingMode = .smart()) {
        guard shouldLog() else {
            logDisabledAudioMessage()
            return
        }
        settingsQueue.sync {
            logDetailedSettings(mode: mode)
        }
    }

    /// Logs detailed settings based on the provided logging mode, including thresholds for
    /// skipping logs and determining when to log changes in audio settings.
    ///
    /// - Parameter mode: The logging mode which specifies how detailed the logging should be.
    private func logDetailedSettings(mode: LoggingMode) {
        let currentTime = Date()

        switch mode {
            case .smart(let skipLogThreshold, let logThreshold):
                if shouldSkipLog(currentTime: currentTime, skipLogThreshold: skipLogThreshold) {
                    return
                }

                if shouldLogChanges(currentTime: currentTime, logThreshold: logThreshold) {
                    updateLoggingStates(currentTime: currentTime)
                } else {
                    resetLoggingStates()
                }

            case .complete(let logThreshold):
                if shouldSkipLogForCompleteMode(currentTime: currentTime, logThreshold: logThreshold) {
                    return
                }
                lastLogTime = currentTime
        }

        logCurrentSettings()
    }

    /// Determines whether the log should be skipped in smart mode based on the time since the last
    /// skip log.
    ///
    /// - Parameters:
    ///   - currentTime: The current time when the logging check is performed.
    ///   - skipLogThreshold: The time interval threshold for skipping logs.
    /// - Returns: `true` if the log should be skipped due to the skip log threshold;
    /// otherwise, `false`.
    private func shouldSkipLog(currentTime: Date, skipLogThreshold: TimeInterval) -> Bool {
        if let lastSkip = lastSkipLogTime, currentTime.timeIntervalSince(lastSkip) < skipLogThreshold {
            return true
        }
        return false
    }

    /// Determines whether logging should occur based on the log threshold and changes in the
    /// audio settings state.
    ///
    /// - Parameters:
    ///   - currentTime: The current time when the logging check is performed.
    ///   - logThreshold: The time interval threshold for logging.
    /// - Returns: `true` if logging should occur; otherwise, `false`.
    private func shouldLogChanges(currentTime: Date, logThreshold: TimeInterval) -> Bool {
        if let lastTime = lastLogTime, currentTime.timeIntervalSince(lastTime) < logThreshold {
            let currentAppWideEnabled = _appWideEnabled
            let currentAudioEnabled = settings.isEnabled
            let appWideChanged = (lastAppWideEnabledState != currentAppWideEnabled)
            let audioEnabledChanged = (lastAudioEnabledState != currentAudioEnabled)

            if !appWideChanged && !audioEnabledChanged {
                logger.info("Skipping log: within threshold period and no significant changes detected.")
                lastSkipLogTime = currentTime
                return false
            }
        }
        return true
    }

    /// Resets the logging states to reflect the current audio settings values.
    private func resetLoggingStates() {
        lastAppWideEnabledState = _appWideEnabled
        lastAudioEnabledState = settings.isEnabled
    }

    /// Updates the logging states and the last log time to the current values.
    ///
    /// - Parameter currentTime: The current time when the log is recorded.
    private func updateLoggingStates(currentTime: Date) {
        lastLogTime = currentTime
        resetLoggingStates()
    }

    /// Determines whether the log should be skipped in complete mode based on the time since the
    /// last log.
    ///
    /// - Parameters:
    ///   - currentTime: The current time when the logging check is performed.
    ///   - logThreshold: The time interval threshold for logging.
    /// - Returns: `true` if the log should be skipped due to the log threshold; otherwise, `false`.
    private func shouldSkipLogForCompleteMode(currentTime: Date, logThreshold: TimeInterval) -> Bool {
        if let lastTime = lastLogTime, currentTime.timeIntervalSince(lastTime) < logThreshold {
            return true
        }
        return false
    }

    /// Logs the current settings related to audio feedback, including device capabilities and
    /// the current configuration of audio settings.
    private func logCurrentSettings() {
        let settingsInfo: [String: Any] = [
            "CurrentSettings": [
                "audioEffectsEnabled": _appWideEnabled,
                "audioLoggingEnabled": settings.isLoggingEnabled,
                "audioLastLogTime": lastLogTime?.formatted(.iso8601) ?? Date.now.formatted(.iso8601),
                "audioLastAppWideEnabledState": lastAppWideEnabledState ?? false,
                "audioLastAudioEnabledState": lastAudioEnabledState ?? false,
                "audioLastKnownLoggingState": lastKnownLoggingState ?? false,
                "audioLastSkipLogTime": lastSkipLogTime?.formatted(.iso8601) ?? Date.now.formatted(.iso8601)
            ]
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: settingsInfo, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            logger.log("\(jsonString, privacy: .public)")
        }
    }

    /// Logs a message indicating that audio has been disabled via user defaults.
    private func logDisabledAudioMessage() {
        userDefaultsDisabledLogCount += 1
        if userDefaultsDisabledLogCount <= logThreshold {
            logger.info("Audio has been disabled via UserDefaults.")
        }
    }

    /// Logs a message indicating that audio logging is not enabled in production mode, limited
    /// to once.
    private func logProductionModeMessage() {
        guard productionModeLogCount == 0 else { return }
        logger.info("Audio logging is not enabled in production mode.")
        productionModeLogCount += 1
    }
}

// MARK: - Playback methods

extension AudioManager {

    /// Plays a system sound if app-wide audio effects are enabled.
    ///
    /// This method checks the current settings and plays the specified system sound if audio
    /// effects are enabled. Additionally, it logs the action according to the specified
    /// `LoggingMode`, which can be either `.smart` or `.complete`.
    ///
    /// - Parameters:
    ///   - sound: The `SystemSound` to be played.
    ///   - loggingMode: The mode in which to log the playback action, defaulting to `.smart()`.
    internal func play(_ sound: SystemSound, loggingMode: LoggingMode = .smart()) async {
        guard await canPlayAudio() else { return }
        if loggingMode.isComplete || loggingMode.isSmart { logSettings(mode: loggingMode) }

        let baseUrl = "/System/Library/Audio/UISounds/"
        guard let url = URL(string: baseUrl + sound.rawValue) else {
            logger.error("Invalid URL for system sound \(sound.rawValue, privacy: .public)")
            return
        }
        playSound(url: url)
    }

    /// Plays a custom sound if app-wide audio effects are enabled.
    ///
    /// This method checks the current settings and plays the specified custom sound if audio
    /// effects are enabled. It also logs the playback action according to the specified
    /// `LoggingMode`.
    ///
    /// - Parameters:
    ///   - sound: The `SoundRepresentable` custom sound to be played.
    ///   - loggingMode: The mode in which to log the playback action, defaulting to `.smart()`.
    internal func play(_ sound: SoundRepresentable, loggingMode: LoggingMode = .smart()) async {
        guard await canPlayAudio() else { return }
        if loggingMode.isComplete || loggingMode.isSmart { logSettings(mode: loggingMode) }

        playSoundFile(name: sound.soundFile.name, extension: sound.soundFile.extension.rawValue)
    }

    /// Plays an audio file from a given URL.
    ///
    /// This method attempts to play an audio file located at the specified URL. It first
    /// creates a `SystemSoundID` from the URL and plays the sound. If the sound ID cannot
    /// be created or if the URL is invalid, it logs an error.
    ///
    /// - Parameter url: The URL of the audio file to play.
    private func playSound(url: URL) {
        var soundID: SystemSoundID = 0
        let status = AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
        if status != kAudioServicesNoError {
            logger.error("Unable to create sound ID for URL: \(url.absoluteString, privacy: .public)")
            return
        }
        AudioServicesPlaySystemSound(soundID)
        AudioServicesDisposeSystemSoundID(soundID)
    }

    /// Plays an audio file located within the app bundle.
    ///
    /// This method locates an audio file within the app bundle by its name and file extension,
    /// and attempts to play it. If the file cannot be found or played, it logs an error.
    ///
    /// - Parameters:
    ///   - name: The name of the audio file.
    ///   - ext: The file extension of the audio file.
    private func playSoundFile(name: String, extension ext: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            logger.error("Unable to find audio file with name: \(name, privacy: .public).\(ext, privacy: .public)")
            return
        }
        playSound(url: url)
    }
}

// MARK: - Helper Methods

extension AudioManager {

    /// Checks whether audio feedback can be triggered based on user settings.
    ///
    /// This method returns a boolean indicating whether audio feedback is enabled app-wide
    /// according to the user's settings. It ensures that audio playback only occurs if the
    /// `appWideEnabled` property is `true`.
    ///
    /// - Returns: `true` if audio feedback can be triggered; otherwise, `false`.
    private func canPlayAudio() async -> Bool {
        guard appWideEnabled else { return false }
        return true
    }
}
