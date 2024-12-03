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

    /// A Boolean property that determines whether the current platform can play audio.
    ///
    /// - Returns: `true` if the platform supports audio playback and an audio output is
    /// available, `false` otherwise.
    /// - Platform-specific behavior:
    ///   - **iOS, tvOS, macCatalyst, visionOS**:
    ///     Uses `AVAudioSession` to configure and check the audio output route.
    ///   - **macOS**:
    ///     Queries the Core Audio API to check for the default output device.
    ///   - **Other Platforms**:
    ///     Returns `false` as audio compatibility is not supported.
    ///
    /// The implementation ensures that the audio session is correctly configured and activated
    /// on applicable platforms. On macOS, it verifies that the system's default audio output device
    /// is available and valid.
    internal static var canPlayAudio: Bool {

        #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(visionOS)

        // Use AVAudioSession to check audio output capabilities.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.ambient, options: [])
            try audioSession.setActive(true)
        } catch {
            return false
        }

        // Ensure there is at least one audio output route available.
        let currentRoute = audioSession.currentRoute
        return !currentRoute.outputs.isEmpty

        #elseif os(macOS)

        // Query Core Audio to check for a valid default output device.
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

        // Return true if the default output device is valid and the status is successful.
        return status == noErr && deviceID != 0

        #else

        // Return false for unsupported platforms.
        return false

        #endif
    }
}
