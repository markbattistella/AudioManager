//
// Project: AudioManager — Example App
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import AudioManager
import SwiftUI

@main
struct AudioManagerExampleApp: App {

  init() {
    // Enable audio effects so perform() calls are not gated out.
    UserDefaults.audio.set(true, for: AudioUserDefaultsKey.audioEffectsEnabled)
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
