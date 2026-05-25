//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

extension UserDefaults {

  /// A `UserDefaults` instance specifically used for managing audio-related settings.
  ///
  /// This accessor uses a dedicated suite name so audio-related values do not collide with
  /// the app's standard defaults. If the suite cannot be created, the standard `UserDefaults`
  /// instance is used as a fallback.
  public static var audio: UserDefaults {
    UserDefaults(suiteName: AudioUserDefaultsKey.suiteName) ?? .standard
  }
}
