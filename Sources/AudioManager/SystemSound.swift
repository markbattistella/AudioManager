//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// An enumeration that represents different types of system sounds.
/// Each case corresponds to a category of sounds available in the system library.
public enum SystemSound {

    /// Represents modern system sounds.
    case modern(ModernSystemSound)

    /// Represents system sounds specifically for Nano.
    case nano(NanoSystemSound)

    /// Represents newly introduced system sounds.
    case new(NewSystemSound)

    /// Represents user interface related system sounds.
    case ui(UISystemSound)
}

extension SystemSound {

    /// The base path for all system sounds in the system library.
    internal static let basePath: String = "/System/Library/Audio/UISounds/"

    /// A computed property that returns the URL for the system sound file based on the sound type.
    ///
    /// - Returns: A `URL` pointing to the system sound file if the path is valid, otherwise `nil`.
    public var url: URL? {
        switch self {
            case .modern(let modernSound):
                return URL(string: modernSound.path)
            case .nano(let nanoSound):
                return URL(string: nanoSound.path)
            case .new(let newSound):
                return URL(string: newSound.path)
            case .ui(let uISound):
                return URL(string: uISound.path)
        }
    }
}
