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
internal final class AudioUserDefaultsSettings: AudioSettings {

    /// The user defaults object for storing settings.
    private let defaults = UserDefaults.standard

    /// The key for storing whether audio feedback is enabled.
    private let audioEnabledKey: any UserDefaultsKeyRepresentable

    /// The key for storing whether logging is enabled.
    private let audioLoggingEnabledKey: any UserDefaultsKeyRepresentable

    /// Initializes a new instance of `AudioUserDefaultsSettings` with the specified keys.
    ///
    /// - Parameters:
    ///   - audioEnabledKey: The key for storing whether audio feedback is enabled.
    ///   - loggingEnabledKey: The key for storing whether logging is enabled.
    internal init(
        audioEnabledKey: any UserDefaultsKeyRepresentable,
        audioLoggingEnabledKey: any UserDefaultsKeyRepresentable
    ) {
        self.audioEnabledKey = audioEnabledKey
        self.audioLoggingEnabledKey = audioLoggingEnabledKey
    }

    /// A Boolean value indicating whether audio feedback is enabled based on user settings.
    internal var isEnabled: Bool { defaults.bool(for: audioEnabledKey) }

    /// A Boolean value indicating whether logging is enabled for audio actions.
    internal var isLoggingEnabled: Bool { defaults.bool(for: audioLoggingEnabledKey) }
}
