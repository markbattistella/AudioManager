//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

// MARK: - Audio Playback Actions

#if os(iOS)

/// Plays a system sound through the shared `AudioManager` instance.
///
/// This function triggers the playback of a system sound asynchronously using the shared
/// `AudioManager` instance. It is only available on iOS platforms. The sound is played
/// if the app-wide audio settings permit.
///
/// - Parameter sound: The `SystemSound` to be played. This represents a predefined system
/// sound available on iOS devices.
public func play(_ sound: SystemSound) {
    Task { await AudioManager.shared.play(sound) }
}

#endif

/// Plays a custom sound through the shared `AudioManager` instance.
///
/// This function triggers the playback of a custom sound asynchronously using the shared
/// `AudioManager` instance. The sound is played if the app-wide audio settings permit.
/// The custom sound must conform to the `SoundRepresentable` protocol, which provides
/// the necessary details for locating and playing the sound.
///
/// - Parameter sound: The `SoundRepresentable` custom sound to be played. This represents
/// a custom sound defined by the app that conforms to the `SoundRepresentable` protocol.
public func play(_ sound: SoundRepresentable) {
    Task { await AudioManager.shared.play(sound) }
}
