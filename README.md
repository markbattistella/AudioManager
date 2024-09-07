# AudioManager

`AudioManager` is a Swift package designed to handle audio playback within your iOS applications. It offers a centralised approach to managing system and custom sounds, based on user preferences stored in `UserDefaults`. The package provides configurable options for enabling/disabling audio effects and logging for debugging purposes.

## Features

- **Global Access Functions:** Simplifies usage by providing global functions for audio playback, avoiding direct access to the singleton instance.
- **System and Custom Sounds:** Supports playback of predefined system sounds and custom sound files.
- **UserDefaults Integration:** Configures audio settings like sound effects and logging directly from user preferences.
- **Thread-Safe Access:** Ensures thread-safe management of audio settings using GCD.
- **Extensible Design:** Easily extendable for additional sound types and future platform support.

## Installation

Add `AudioManager` to your Swift project using Swift Package Manager.

```swift
dependencies: [
  .package(url: "https://github.com/markbattistella/AudioManager", from: "1.0.0")
]
```

## Usage

### Basic Setup

`AudioManager` provides global functions to simplify audio playback. To play a system sound, use:

```swift
import AudioManager

// Play a system sound
play(.smsReceived1)
```

To play a custom sound:

```swift
import AudioManager

// Define a custom sound
let customSound = SoundRepresentable(soundFile: SoundFile(name: "customSound", extension: .mp3))

// Play the custom sound
play(customSound)
```

### Configuring Audio Settings

`AudioManager` uses `UserDefaults` for storing audio settings. The package provides default keys through the `AudioUserDefaultKeys` enum, which you can use to set preferences:

```swift
import AudioManager

// Enable audio effects
UserDefaults.standard.set(true, forKey: AudioUserDefaultKeys.audioEffectsEnabled.rawValue)

// Enable logging
UserDefaults.standard.set(true, forKey: AudioUserDefaultKeys.audioLoggingEnabled.rawValue)
```

### Customising Logging

Logging can be enabled or disabled based on the user's preferences. This setting controls whether playback and error messages are printed, aiding in debugging:

```swift
// Toggle logging preference
UserDefaults.standard.set(true, forKey: AudioUserDefaultKeys.audioLoggingEnabled.rawValue)
```

### Injecting Custom Settings

For testing or advanced configurations, you can inject custom settings into `AudioManager`:

```swift
import AudioManager

// Define a custom settings object conforming to AudioSettings protocol
let mockSettings = MockAudioSettings(isEnabled: true, isLoggingEnabled: false)

// Set the custom settings
AudioManager.shared.setCustomSettings(mockSettings) // Internal use, if needed for testing
```

## Extending System Sounds

To add more system sounds, extend the `SystemSound` enum with new cases:

```swift
public enum SystemSound: String {
  case customSound = "custom-sound.caf"
}
```

## Contributing

Contributions are welcome! Please submit a pull request or open an issue if you have suggestions or improvements.

## License

`AudioManager` is licensed under the MIT License. See the LICENSE file for more details.
