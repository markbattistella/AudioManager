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

  /// The current playback behavior — whether audio respects the ringer switch or volume level.
  public static var playbackBehavior: AudioPlaybackBehavior {
    AudioFeedbackSettings.playbackBehavior
  }

  /// Performs the specified playback action if audio feedback is available and enabled.
  ///
  /// - Parameter action: The playback action to be performed (`.system` or `.custom`).
  public static func perform(_ action: Playback) {
    let behavior = AudioFeedbackSettings.playbackBehavior
    guard canPerform(for: behavior) else { return }

    switch action {
    case .system(let systemSound):
      play(url: systemSound.url, behavior: behavior)
    case .custom(let customSound):
      play(url: getURL(for: customSound), behavior: behavior)
    }
  }
}

// MARK: - Helper Methods

extension AudioFeedbackPerformer {

  /// Checks whether audio feedback can currently be performed under the given behavior.
  internal static func canPerform(for behavior: AudioPlaybackBehavior) -> Bool {
    guard isAvailable && isEnabled else { return false }
    #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(visionOS)
      if behavior == .respectVolume {
        return AudioCompatibility.outputVolume > 0
      }
    #endif
    return true
  }

  /// Convenience wrapper used by `TriggerActionPerformable` before `perform` is called.
  internal static func canPerform() -> Bool {
    canPerform(for: AudioFeedbackSettings.playbackBehavior)
  }
}

// MARK: - Package Specific Logic

extension AudioFeedbackPerformer {

  /// Resolves the URL and routes playback through the appropriate engine for `behavior`.
  private static func play(url: URL?, behavior: AudioPlaybackBehavior) {
    guard let url else { return }

    AudioCompatibility.configureSession(for: behavior)

    switch behavior {
    case .respectRinger:
      // AudioServicesPlaySystemSound natively respects the ringer switch — no extra
      // session setup needed.
      let soundID = makeSystemSoundID(from: url)
      playSystemSound(withID: soundID)

    case .respectVolume:
      #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(visionOS)
        // AVAudioPlayer with .playback session bypasses the ringer switch.
        AudioPlayerCoordinator.shared.play(url: url)
      #else
        // macOS has no ringer switch concept; fall back to system sound.
        let soundID = makeSystemSoundID(from: url)
        playSystemSound(withID: soundID)
      #endif
    }
  }

  // MARK: AudioServices helpers

  private static func makeSystemSoundID(from url: URL) -> SystemSoundID? {
    var soundID: SystemSoundID = 0
    guard AudioServicesCreateSystemSoundID(url as CFURL, &soundID) == noErr else {
      return nil
    }
    return soundID
  }

  private static func playSystemSound(withID id: SystemSoundID?) {
    guard let id else { return }
    AudioServicesAddSystemSoundCompletion(
      id,
      nil,
      nil,
      { id, _ in AudioServicesDisposeSystemSoundID(id) },
      nil
    )
    AudioServicesPlaySystemSound(id)
  }

  // MARK: Custom sound URL resolution

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
