//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import DefaultsKit

/// An externally accessible enumeration that defines keys for UserDefaults settings.
///
/// Conforming to `UserDefaultsKeyRepresentable` allows these keys to be easily used
/// with UserDefaults for storing and retrieving values.
public enum AudioUserDefaultKeys: String, UserDefaultsKeyRepresentable {
    
    /// Key for the user's preference on whether audio effects are enabled.
    case audioEffectsEnabled
    
    /// Key for the user's preference on whether logging is enabled for audio actions.
    case audioLoggingEnabled

    /// Key for tracking the number of log attempts.
    case audioLogAttemptCount

    /// Key for storing the last log date.
    case audioLogLastLogDate

    /// Key for the logging threshold value.
    case audioLogThreshold

    /// Key for the logging cooldown period.
    case audioLogCooldown
}
