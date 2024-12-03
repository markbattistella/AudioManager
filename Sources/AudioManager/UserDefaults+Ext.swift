//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

extension UserDefaults {

    /// A `UserDefaults` instance specifically used for managing audio-related settings.
    ///
    /// This instance is created using an app group identifier to allow shared access between app
    /// extensions. If the app group cannot be found, the standard `UserDefaults` instance is used
    /// as a fallback.
    ///
    /// - Note: The app group identifier must be correctly configured for this to work. This allows
    /// for storing shared settings that can be accessed across different parts of the app, such
    /// as extensions or widgets.
    nonisolated(unsafe)
        public static let audio: UserDefaults = {
            let appGroupIdentifier = "com.markbattistella.audioManager"

            // Attempt to create a UserDefaults instance for the given app group.
            guard let userDefaults = UserDefaults(suiteName: appGroupIdentifier) else {

                // Fallback to standard UserDefaults if app group UserDefaults cannot be created.
                return .standard
            }

            return userDefaults
        }()
}
