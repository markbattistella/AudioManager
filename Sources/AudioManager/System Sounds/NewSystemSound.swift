//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

extension SystemSound {

    /// Represents a collection of newly introduced system sounds available for playback.
    ///
    /// The `NewSystemSound` enum defines sound files typically used for new audio interactions
    /// within the system. This enum provides an easy way to reference sound files by name and
    /// retrieve their paths.
    public enum NewSystemSound: String, SystemSoundRepresentable {

        /// The folder name where the new system sounds are stored.
        internal var folderName: String { "New/" }

        // MARK: - New System Sounds

        /// Represents the sound for typewriters.
        case typewriters = "Typewriters.caf"

        /// Represents the sound for updates.
        case update = "Update.caf"
    }
}
