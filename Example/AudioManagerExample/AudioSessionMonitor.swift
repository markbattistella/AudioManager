//
// Project: AudioManager — Example App
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import AVFAudio
import Foundation

/// Watches AVAudioSession.outputVolume via KVO so the UI can react to volume changes.
final class AudioSessionMonitor: NSObject, ObservableObject {

  @Published private(set) var outputVolume: Float = 0

  override init() {
    super.init()
    let session = AVAudioSession.sharedInstance()
    try? session.setActive(true)
    outputVolume = session.outputVolume
    session.addObserver(self, forKeyPath: "outputVolume", options: .new, context: nil)
  }

  deinit {
    AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: "outputVolume")
  }

  override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey: Any]?,
    context: UnsafeMutableRawPointer?
  ) {
    guard keyPath == "outputVolume" else { return }
    DispatchQueue.main.async {
      self.outputVolume = AVAudioSession.sharedInstance().outputVolume
    }
  }
}
