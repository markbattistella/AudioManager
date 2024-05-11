//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// Protocol defining requirements for objects that represent sound files.
/// Conforming types must provide a sound file's name and extension.
public protocol SoundRepresentable {

    /// A tuple containing the name and extension of a sound file.
    var soundFile: (name: String, extension: AudioFileExtension) { get }
}

/// Enum representing supported audio file extensions.
public enum AudioFileExtension: String {
    case wav
    case mp3
    case aif
    case caf
    case m4a
}
