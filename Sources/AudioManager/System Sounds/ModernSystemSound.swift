//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

extension SystemSound {

    /// Represents a collection of modern system sounds available for playback.
    ///
    /// The `ModernSystemSound` enum defines a series of sound files typically used for system-level
    /// interactions such as camera operations. These sounds can be used to provide the user with
    /// feedback related to common actions.
    public enum ModernSystemSound: String, SystemSoundRepresentable {

        /// The folder name where the modern system sounds are stored.
        internal var folderName: String { "Modern/" }

        // MARK: - Modern System Sounds

        /// The sound played when a camera shutter burst begins.
        case cameraShutterBurstBegin = "camera_shutter_burst_begin.caf"

        /// The sound played when a camera shutter burst ends.
        case cameraShutterBurstEnd = "camera_shutter_burst_end.caf"

        /// The sound played for a camera shutter during a burst capture.
        case cameraShutterBurst = "camera_shutter_burst.caf"
    }
}
