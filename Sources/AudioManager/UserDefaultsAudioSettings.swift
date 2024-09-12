//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import DefaultsKit

/// A class that provides access to audio and logging settings stored in UserDefaults.
///
/// This class retrieves values using specified keys and provides default values if none are set.
/// It conforms to the `AudioSettings` protocol to ensure compatibility with the AudioManager.
final class AudioUserDefaultsSettings: AudioSettings {

    /// The key for storing whether audio feedback is enabled.
    private let audioEnabledKey: any UserDefaultsKeyRepresentable

    /// The key for storing whether logging is enabled.
    private let audioLoggingEnabledKey: any UserDefaultsKeyRepresentable

    /// The key for storing the logging threshold value.
    private let audioLoggingThresholdKey: any UserDefaultsKeyRepresentable

    /// The key for storing the logging cooldown period.
    private let audioLoggingCooldownKey: any UserDefaultsKeyRepresentable

    /// Default threshold for logging attempts before logging is allowed.
    private let defaultThreshold: Int = 20

    /// Default cooldown period in seconds before allowing another log.
    private let defaultCooldown: TimeInterval = 120

    /// Initializes a new instance of `AudioUserDefaultsSettings` with the specified keys.
    ///
    /// - Parameters:
    ///   - audioEnabledKey: The key for storing whether audio feedback is enabled.
    ///   - loggingEnabledKey: The key for storing whether logging is enabled.
    ///   - loggingThresholdKey: The key for storing the logging threshold.
    ///   - loggingCooldownKey: The key for storing the logging cooldown period.
    internal init(
        audioEnabledKey: any UserDefaultsKeyRepresentable,
        audioLoggingEnabledKey: any UserDefaultsKeyRepresentable,
        audioLoggingThresholdKey: any UserDefaultsKeyRepresentable,
        audioLoggingCooldownKey: any UserDefaultsKeyRepresentable
    ) {
        self.audioEnabledKey = audioEnabledKey
        self.audioLoggingEnabledKey = audioLoggingEnabledKey
        self.audioLoggingThresholdKey = audioLoggingThresholdKey
        self.audioLoggingCooldownKey = audioLoggingCooldownKey
    }

    /// A Boolean value indicating whether audio feedback is enabled based on user settings.
    internal var isEnabled: Bool {
        UserDefaults.standard.bool(for: audioEnabledKey)
    }

    /// A Boolean value indicating whether logging is enabled for audio actions.
    internal var isLoggingEnabled: Bool {
        UserDefaults.standard.bool(for: audioLoggingEnabledKey)
    }

    /// The logging threshold value, with a default if not set.
    internal var loggingThreshold: Int {
        UserDefaults.standard.integer(for: audioLoggingThresholdKey) > 0
        ? UserDefaults.standard.integer(for: audioLoggingThresholdKey)
        : defaultThreshold
    }

    /// The logging cooldown value, with a default if not set.
    internal var loggingCooldown: TimeInterval {
        UserDefaults.standard.double(for: audioLoggingCooldownKey) > 0
        ? UserDefaults.standard.double(for: audioLoggingCooldownKey)
        : defaultCooldown
    }
}
