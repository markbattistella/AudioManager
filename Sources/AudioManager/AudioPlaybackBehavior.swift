//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// Defines how audio feedback responds to the device's output controls.
public enum AudioPlaybackBehavior: Int, Sendable {

  /// Audio respects the hardware ringer/silent switch.
  ///
  /// Sound plays only when the ringer switch is set to ring (not silent). The device volume
  /// level has no effect — the ringer switch alone determines whether the sound is audible.
  case respectRinger = 0

  /// Audio respects the device volume level, bypassing the ringer/silent switch.
  ///
  /// Sound plays whenever the output volume is greater than zero, regardless of the ringer
  /// switch position. Use this when the sound is integral to the user experience and should
  /// not be silenced by the ringer switch (e.g. game audio, timer alerts).
  case respectVolume = 1
}
