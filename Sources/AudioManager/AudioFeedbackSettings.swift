//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import DefaultsKit
import Foundation

/// A utility struct that handles the settings for audio feedback functionality.
internal struct AudioFeedbackSettings {

    // MARK: - Properties

    /// The `UserDefaults` instance used for storing and retrieving audio feedback settings.
    ///
    /// - Note: This uses a custom `UserDefaults` instance named `.audio`.
    internal static var defaults: UserDefaults { .audio }

    /// The key used in `UserDefaults` to check if audio effects are enabled.
    internal static var isAudioEnabledKey: any UserDefaultsKeyRepresentable {
        AudioUserDefaultsKey.audioEffectsEnabled
    }

    /// A flag indicating whether audio feedback is available.
    internal static var isAudioAvailable: Bool {
        AudioCompatibility.canPlayAudio
    }

    /// A flag indicating whether audio feedback is currently enabled by the user.
    internal static var isAudioEnabled: Bool {
        defaults.bool(for: isAudioEnabledKey)
    }
}
