//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// A protocol representing an object that can provide a custom sound representation. Types
/// conforming to `CustomSoundRepresentable` must provide a `SoundFile` that defines the
/// audio properties.
public protocol CustomSoundRepresentable: Sendable {

    /// The sound file associated with the conforming type.
    var soundFile: SoundFile { get }
}

// MARK: - SoundFile Struct

/// A structure representing a sound file, consisting of a name and an audio file extension.
public struct SoundFile {

    // MARK: - Properties

    /// The name of the sound file, without the file extension.
    ///
    /// - Important: This should match the actual file name stored in the project or bundle.
    internal let name: String

    /// The file extension of the sound file. This is restricted to known audio formats through
    /// the `AudioFileExtension` enum.
    internal let `extension`: AudioFileExtension

    // MARK: - Initializer

    /// Initializes a `SoundFile` with a given name and audio file extension.
    /// - Parameters:
    ///   - name: The name of the sound file without its extension.
    ///   - ext: The audio file extension, specified as a value from `AudioFileExtension`.
    public init(
        name: String,
        extension ext: AudioFileExtension
    ) {
        self.name = name
        self.extension = ext
    }

    // MARK: - AudioFileExtension Enum

    /// Enum representing supported audio file extensions.
    public enum AudioFileExtension: String {

        /// Waveform Audio File Format
        case wav

        /// Audio Interchange File Format
        case aif

        /// Audio Interchange File Format, standard variant
        case aiff

        /// Core Audio Format
        case caf

        /// MPEG-1 or MPEG-2 Audio Layer III
        case mp3
    }
}
