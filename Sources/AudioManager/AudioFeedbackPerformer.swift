//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import AudioToolbox
import Foundation
import TriggerKit

/// A utility structure that facilitates the playing of audio feedback in response to specific
/// triggers.
///
/// The `AudioFeedbackPerformer` structure is designed to manage and execute audio feedback actions
/// when a particular state or event occurs. It uses a generic parameter `T` that must conform to
/// `Equatable`, allowing it to respond to changes in application state or user interactions. This
/// structure supports both system sounds and custom sounds that can be defined externally, making
/// it highly flexible for different audio feedback scenarios.
///
/// Conforms to `TriggerActionPerformable` to ensure seamless integration into various application
/// workflows where actions are triggered based on state or events.
public struct AudioFeedbackPerformer<T> where T: Equatable {}

extension AudioFeedbackPerformer: TriggerActionPerformable {

    /// The type of trigger for the action, defined by generic type `T`.
    public typealias Trigger = T

    /// Enum representing different types of playback for audio feedback.
    public enum Playback {

        /// System-defined sounds, available from iOS 13.0 onwards.
        @available(iOS 13.0, *)
        case system(SystemSound)

        /// Custom sound, provided by conforming to `CustomSoundRepresentable`.
        case custom(CustomSoundRepresentable)
    }

    /// A flag indicating whether audio feedback is available for use.
    public static var isAvailable: Bool {
        AudioFeedbackSettings.isAudioAvailable
    }

    /// A flag indicating whether audio feedback is currently enabled.
    public static var isEnabled: Bool {
        AudioFeedbackSettings.isAudioEnabled
    }

    /// Performs the specified playback action if audio feedback is available and enabled.
    ///
    /// - Parameter action: The playback action to be performed (`.system` or `.custom`).
    public static func perform(_ action: Playback) {
        guard canPerform() else { return }

        switch action {
            case .system(let systemSound):
                play(systemSound: systemSound)
            case .custom(let customSound):
                play(customSound: customSound)
        }
    }
}

// MARK: - Helper Methods

extension AudioFeedbackPerformer {

    /// Checks whether audio feedback can currently be performed.
    ///
    /// - Returns: `true` if audio feedback is both available and enabled, otherwise `false`.
    internal static func canPerform() -> Bool {
        return isAvailable && isEnabled
    }
}

// MARK: - Package Specific Logic

extension AudioFeedbackPerformer {

    // MARK: Main Methods

    /// Plays a system sound using a given `SystemSound` object.
    ///
    /// - Parameter systemSound: The `SystemSound` to play.
    internal static func play(systemSound: SystemSound) {
        let systemSoundID = getSystemSoundID(from: systemSound.url)
        playSound(withID: systemSoundID)
    }

    /// Plays a custom sound using an object conforming to `CustomSoundRepresentable`.
    ///
    /// - Parameter customSound: The `CustomSoundRepresentable` object representing the custom
    /// sound to be played.
    internal static func play(customSound: CustomSoundRepresentable) {
        let customSoundURL = getURL(for: customSound)
        let customSoundID = getSystemSoundID(from: customSoundURL)
        playSound(withID: customSoundID)
    }

    // MARK: Helper Methods

    /// Gets a system sound ID for a given URL.
    ///
    /// - Parameter url: The URL of the sound file.
    /// - Returns: A `SystemSoundID` if the URL is valid, otherwise `nil`.
    private static func getSystemSoundID(from url: URL?) -> SystemSoundID? {
        var systemSoundID: SystemSoundID = 0
        guard let url else { return nil }
        guard AudioServicesCreateSystemSoundID(url as CFURL, &systemSoundID) == noErr else {
            print("Failed to create system sound ID")
            return nil
        }
        return systemSoundID
    }

    /// Plays a sound given its system sound ID.
    ///
    /// - Parameter id: The `SystemSoundID` to be played.
    private static func playSound(withID id: SystemSoundID?) {
        guard let id else {
            print("Invalid system sound ID")
            return
        }
        AudioServicesAddSystemSoundCompletion(
            id,
            nil,
            nil,
            { id, _ in AudioServicesDisposeSystemSoundID(id) },
            nil
        )
        AudioServicesPlaySystemSound(id)
    }

    /// Gets a URL for a custom sound provided by an object conforming to `CustomSoundRepresentable`.
    ///
    /// - Parameter customSound: The `CustomSoundRepresentable` object representing the custom sound.
    /// - Returns: The URL for the custom sound file if available, otherwise `nil`.
    private static func getURL(for customSound: CustomSoundRepresentable) -> URL? {
        guard
            let audioFilePath = Bundle.main.path(
                forResource: customSound.soundFile.name,
                ofType: customSound.soundFile.extension.rawValue
            )
        else { return nil }

        if #available(iOS 16.0, macCatalyst 16.0, macOS 13.0, tvOS 16.0, visionOS 1.0, *) {
            return URL(filePath: audioFilePath, directoryHint: .notDirectory)
        } else {
            return URL(fileURLWithPath: audioFilePath)
        }
    }
}
