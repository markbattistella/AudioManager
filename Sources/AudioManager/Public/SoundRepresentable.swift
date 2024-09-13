//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// Protocol defining requirements for objects that represent sound files. Conforming types
/// must provide a sound file's name and extension.
public protocol SoundRepresentable: Sendable {
    
    /// The sound file associated with the sound.
    var soundFile: SoundFile { get }
}

/// Represents a custom sound file with a name and file extension.
/// This struct is used by `SoundRepresentable` conforming types to specify sound files.
public struct SoundFile {
    
    /// The name of the sound file.
    let name: String
    
    /// The file extension of the sound file.
    let `extension`: AudioFileExtension
}

/// Enum representing supported audio file extensions.
public enum AudioFileExtension: String {
    case wav, mp3, aif, caf, m4a
}
