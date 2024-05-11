//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import AVFoundation
import DefaultsKit

/// A singleton class responsible for managing audio playback throughout the app.
internal final class AudioManager {

    /// The shared instance of `AudioManager` for app-wide use.
    internal static let shared = AudioManager()

    /// The key used to retrieve audio settings from `UserDefaults`.
    private let key: UserDefaultsKeyRepresentable = UserDefaultKeys.settingsAudioEffectsEnabled

    /// A private property that tracks whether audio effects are enabled app-wide.
    private var _appWideEnabled: Bool

    /// A public read-only property indicating whether audio effects are enabled app-wide.
    internal var appWideEnabled: Bool { _appWideEnabled }

    /// Initializes the `AudioManager` instance.
    private init() {
        _appWideEnabled = UserDefaults.standard.bool(for: key)
        observeUserDefaultsChanges()
    }

    /// Sets up an observer to listen for changes in `UserDefaults` that affect the app's 
    /// audio settings.
    private func observeUserDefaultsChanges() {
        NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification, object: nil, queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            self._appWideEnabled = UserDefaults.standard.bool(for: key)
        }
    }

    // MARK: Playback methods

    #if os(iOS)

    /// Plays a system sound if app-wide audio effects are enabled.
    ///
    /// - Parameter sound: The `SystemSound` to be played.
    internal func play(_ sound: SystemSound) {
        guard appWideEnabled else { return }
        let baseUrl = "/System/Library/Audio/UISounds/"
        guard let url = URL(string: baseUrl + sound.rawValue) else { return }
        playSound(url: url)
    }

    #endif

    /// Plays a custom sound if app-wide audio effects are enabled.
    ///
    /// - Parameter sound: The `SoundRepresentable` custom sound to be played.
    internal func play(_ sound: SoundRepresentable) {
        guard appWideEnabled else { return }
        playSoundFile(name: sound.soundFile.name, extension: sound.soundFile.extension.rawValue)

    }


    // MARK: Helper methods

    /// Plays an audio file from a given URL.
    ///
    /// - Parameter url: The URL of the audio file to play.
    private func playSound(url: URL) {
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }

    /// Plays an audio file located within the app bundle.
    ///
    /// - Parameters:
    ///   - name: The name of the audio file.
    ///   - ext: The file extension of the audio file.
    private func playSoundFile(name: String, extension ext: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else { return }
        playSound(url: url)
    }

}

// MARK: - Audio Playback Actions

#if os(iOS)

/// Plays a system sound through the shared `AudioManager` instance.
///
/// - Parameter sound: The `SystemSound` to be played.
public func play(_ sound: SystemSound) {
    AudioManager.shared.play(sound)
}

#endif

/// Plays a custom sound through the shared `AudioManager` instance.
///
/// - Parameter sound: The `SoundRepresentable` custom sound to be played.
public func play(_ sound: SoundRepresentable) {
    AudioManager.shared.play(sound)
}
