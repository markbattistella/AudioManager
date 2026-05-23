//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(visionOS)
  import AVFAudio

  /// Manages the lifecycle of `AVAudioPlayer` instances used for volume-respecting playback.
  ///
  /// `AVAudioPlayer` must be retained for the duration of playback; releasing it immediately
  /// after `play()` silently stops the sound. This coordinator keeps each player alive until
  /// its delegate callback fires, then discards it.
  internal final class AudioPlayerCoordinator: NSObject, @unchecked Sendable {

    internal static let shared = AudioPlayerCoordinator()

    private var players: [AVAudioPlayer] = []
    private let lock = NSLock()

    private override init() { super.init() }

    internal func play(url: URL) {
      guard let player = try? AVAudioPlayer(contentsOf: url) else { return }
      player.delegate = self
      lock.lock()
      players.append(player)
      lock.unlock()
      player.play()
    }
  }

  extension AudioPlayerCoordinator: AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully: Bool) {
      lock.lock()
      players.removeAll { $0 === player }
      lock.unlock()
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
      lock.lock()
      players.removeAll { $0 === player }
      lock.unlock()
    }
  }
#endif
