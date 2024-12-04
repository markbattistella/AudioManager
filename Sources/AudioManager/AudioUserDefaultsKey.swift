//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import DefaultsKit
import Foundation

/// An enumeration representing keys for storing audio-related settings in `UserDefaults`.
/// Each case corresponds to a specific setting that can be stored and retrieved.
public enum AudioUserDefaultsKey: String, UserDefaultsKeyRepresentable {

    /// A key representing whether audio effects are enabled.
    case audioEffectsEnabled

    /// Default suite name to group all package keys.
    public static var suiteName: String? { "com.markbattistella.audioManager" }
}
