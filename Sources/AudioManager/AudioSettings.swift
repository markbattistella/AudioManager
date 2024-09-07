//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// Protocol defining the necessary settings for audio management. Conforming types provide the
/// ability to determine whether audio effects and logging are enabled.
protocol AudioSettings {
    
    /// Indicates whether audio effects are enabled.
    var isEnabled: Bool { get }
    
    /// Indicates whether logging is enabled for audio actions.
    var isLoggingEnabled: Bool { get }
}
