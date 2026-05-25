//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(visionOS)
  import AVFAudio
#endif

#if os(macOS)
  import CoreAudio
#endif

/// An enumeration that provides compatibility methods and properties for audio playback
/// across different Apple platforms.
internal enum AudioCompatibility {

  /// Whether the current platform has audio output hardware available.
  ///
  /// On iOS/tvOS/visionOS/macCatalyst, checks that the current audio route has at least one
  /// output. On macOS, queries Core Audio for a valid default output device.
  internal static var canPlayAudio: Bool {

    #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(visionOS)

      // These devices always have audio hardware (speaker, earpiece, or headphones).
      // currentRoute.outputs is empty until a session is active, so checking it produces
      // a false negative on a fresh launch — hardware presence is guaranteed by the platform.
      return true

    #elseif os(macOS)

      let defaultOutputDeviceID = AudioObjectID(kAudioObjectSystemObject)
      var propertyAddress = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDefaultOutputDevice,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
      )

      var deviceID: AudioObjectID = 0
      var propertySize = UInt32(MemoryLayout<AudioObjectID>.size)
      let status = AudioObjectGetPropertyData(
        defaultOutputDeviceID,
        &propertyAddress,
        0,
        nil,
        &propertySize,
        &deviceID
      )

      return status == noErr && deviceID != 0

    #else

      return false

    #endif
  }

  /// The current output volume, in the range 0.0–1.0.
  ///
  /// On iOS/tvOS/visionOS/macCatalyst, reads `AVAudioSession.outputVolume`. On other platforms,
  /// returns 1.0 (assume full volume — no ringer concept on those platforms).
  internal static var outputVolume: Float {
    #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(visionOS)
      return AVAudioSession.sharedInstance().outputVolume
    #else
      return 1.0
    #endif
  }

  /// Configures the shared `AVAudioSession` for the given playback behavior.
  ///
  /// - `.respectRinger`: leaves the session unconfigured so `AudioServicesPlaySystemSound`
  ///   can use its native silent-switch-aware path.
  /// - `.respectVolume`: activates a `.playback` session with `.mixWithOthers` so audio plays
  ///   even when the ringer switch is off, without interrupting other app audio. The session
  ///   remains active because `AVAudioSession` is process-wide.
  internal static func configureSession(for behavior: AudioPlaybackBehavior) {
    #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(visionOS)
      guard behavior == .respectVolume else { return }
      let session = AVAudioSession.sharedInstance()
      try? session.setCategory(.playback, options: [.mixWithOthers])
      try? session.setActive(true)
    #endif
  }
}
