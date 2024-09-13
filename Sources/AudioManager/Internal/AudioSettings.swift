//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// A protocol defining the necessary settings for audio management within the application.
///
/// Conforming types provide the ability to determine whether audio effects and logging are
/// enabled based on user settings. This protocol ensures that all audio-related settings
/// are standardized and accessible in a consistent manner across different components.
internal protocol AudioSettings {

    /// A Boolean value indicating whether audio feedback is enabled according to user settings.
    ///
    /// When `true`, audio effects such as system sounds or custom audio cues are permitted
    /// to play based on the user's preferences. This setting allows the application to
    /// respect user choices regarding sound feedback.
    var isEnabled: Bool { get }

    /// A Boolean value indicating whether logging for audio actions is enabled.
    ///
    /// When `true`, the application logs audio-related actions, such as playing sounds or
    /// encountering errors in audio playback, to assist with debugging or auditing.
    /// This setting allows the app to provide detailed logs based on user or developer needs.
    var isLoggingEnabled: Bool { get }
}
