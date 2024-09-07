//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import DefaultsKit

/// Implementation of the `AudioSettings` protocol using UserDefaults.
/// This class fetches user preferences for audio effects and logging from UserDefaults.
final class UserDefaultsAudioSettings: AudioSettings {
    
    /// Key for the user's preference on whether audio effects are enabled.
    private let audioEnabledKey: any UserDefaultsKeyRepresentable
    
    /// Key for the user's preference on whether logging is enabled for audio actions.
    private let loggingEnabledKey: any UserDefaultsKeyRepresentable
    
    /// Initializes the UserDefaultsAudioSettings with specific keys for audio and logging settings.
    /// - Parameters:
    ///   - audioEnabledKey: The key used to check if audio effects are enabled.
    ///   - loggingEnabledKey: The key used to check if logging is enabled.
    init(
        audioEnabledKey: any UserDefaultsKeyRepresentable,
        loggingEnabledKey: any UserDefaultsKeyRepresentable
    ) {
        self.audioEnabledKey = audioEnabledKey
        self.loggingEnabledKey = loggingEnabledKey
    }
    
    /// Retrieves the current setting for audio effects enabled from UserDefaults.
    var isEnabled: Bool {
        UserDefaults.standard.bool(for: audioEnabledKey)
    }
    
    /// Retrieves the current setting for logging enabled from UserDefaults.
    var isLoggingEnabled: Bool {
        UserDefaults.standard.bool(for: loggingEnabledKey)
    }
}
