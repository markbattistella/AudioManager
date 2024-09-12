//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// Protocol defining the necessary settings for audio management. Conforming types provide the
/// ability to determine whether audio effects and logging are enabled.
protocol AudioSettings {

    /// Indicates whether audio feedback is enabled by user settings.
    var isEnabled: Bool { get }

    /// Indicates whether logging for audio actions is enabled.
    var isLoggingEnabled: Bool { get }

    /// Indicates the threshold for logging audio messages.
    var loggingThreshold: Int { get }

    /// Indicates the cooldown period for logging audio messages.
    var loggingCooldown: TimeInterval { get }
}
