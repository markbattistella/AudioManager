<!-- markdownlint-disable MD024 MD033 MD041 -->
<div align="center">

# AudioManager

![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FAudioManager%2Fbadge%3Ftype%3Dswift-versions)

![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FAudioManager%2Fbadge%3Ftype%3Dplatforms)

![Licence](https://img.shields.io/badge/Licence-MIT-white?labelColor=blue&style=flat)

</div>

`AudioManager` is a Swift package that provides a modular and easy-to-use interface for implementing audio feedback in your applications. It integrates seamlessly with SwiftUI, enabling you to enhance user experience through customisable audible feedback.

## Features

- **SwiftUI Extensions:** Add audio feedback to views declaratively via `.audioFeedback(...)`.
- **System Sounds:** Play built-in iOS system sounds via `SystemSound`.
- **Custom Audio:** Bring your own audio files using `CustomSoundRepresentable`.
- **Playback Behaviour:** Choose whether audio respects the ringer/silent switch or the device volume level.
- **User Preferences:** Enable or disable audio feedback globally through a simple `UserDefaults` key.

## Installation

Add `AudioManager` to your Swift project using Swift Package Manager.

```swift
    dependencies: [
                   .package(url: "https://github.com/markbattistella/AudioManager", from: "1.0.0")
                   ]
```

## Usage

There are three ways to trigger audio feedback:

- **Static Action:** Triggers on every state change — ideal for consistent feedback.
- **Static Action with Condition:** Adds a condition closure that gates whether feedback fires.
- **Dynamic Action:** Derives the sound itself from the old and new trigger values.

> [!NOTE]
> `.system(SystemSound)` plays files from `/System/Library/Audio/UISounds/`, which are only present on iOS, tvOS, visionOS, and macCatalyst. On macOS, use `.custom(CustomSoundRepresentable)` with your own bundled audio files.

### Static Action

```swift
    @State private var isSuccess: Bool = false
    
    Button("Toggle") { isSuccess.toggle() }
    .audioFeedback(.system(.ui(.tock)), trigger: isSuccess)
```

### Static Action with Condition

#### Old and new values

```swift
    enum Phase { case inactive, active, completed }
    
    @State private var phase: Phase = .inactive
    
    Button("Advance") { ... }
    .audioFeedback(.system(.ui(.tink)), trigger: phase) { oldValue, newValue in
        oldValue != .completed && newValue == .completed
    }
```

#### New value only

```swift
    Button("Advance") { ... }
    .audioFeedback(.system(.ui(.tink)), trigger: phase) { newValue in
        newValue == .completed
    }
```

#### No parameters

```swift
    Button("Toggle") { phase.toggle() }
    .audioFeedback(.system(.ui(.tink)), trigger: phase) {
        // fires on every change
    }
```

### Dynamic Action

#### Old and new values

```swift
    enum LoadingState { case ready, success, failure }
    
    @State private var loadingState: LoadingState = .ready
    
    Button("Advance") { ... }
    .audioFeedback(trigger: loadingState) { oldValue, newValue in
        switch (oldValue, newValue) {
            case (.failure, .ready):   return .system(.modern(.cameraShutterBurstBegin))
            case (.ready, .success):   return .system(.nano(.screenCapture))
            case (.success, .failure): return .system(.new(.update))
            default:                   return nil
        }
    }
```

#### New value only

```swift
    Button("Advance") { ... }
    .audioFeedback(trigger: loadingState) { newValue in
        switch newValue {
            case .success: return .system(.modern(.cameraShutterBurstBegin))
            case .failure: return .system(.nano(.screenCapture))
            default:       return nil
        }
    }
```

#### No parameters

```swift
    Button("Advance") { ... }
    .audioFeedback(trigger: loadingState) {
        return .system(.ui(.tock))
    }
```

## Playback Behaviour

By default, audio respects the hardware ringer/silent switch — the same behaviour as system UI sounds. You can change this globally so audio instead responds to the device volume level, bypassing the ringer switch entirely.

| Behaviour | Plays when… | Engine |
| --- | --- | --- |
| `.respectRinger` (default) | Ringer switch is **on** | `AudioServicesPlaySystemSound` |
| `.respectVolume` | Device volume is **> 0** | `AVAudioPlayer` (`.playback` session) |

> [!NOTE]
> `AudioPlaybackBehavior` is an iOS/tvOS/visionOS/macCatalyst concept. On macOS there is no ringer switch, so both behaviours fall through to `AudioServicesPlaySystemSound` and behave identically.

Set the behaviour via `UserDefaults.audio`:

```swift
    // Ringer switch controls playback (default)
    UserDefaults.audio.set(
                           AudioPlaybackBehavior.respectRinger.rawValue,
                           for: AudioUserDefaultsKey.audioPlaybackBehavior
                           )
                           
                           // Volume slider controls playback — ringer switch is ignored
                           UserDefaults.audio.set(
                                                  AudioPlaybackBehavior.respectVolume.rawValue,
                                                  for: AudioUserDefaultsKey.audioPlaybackBehavior
                                                  )
```

The `.respectVolume` session is configured with `.mixWithOthers`, so it will not interrupt music or other audio playing in the background.

Read the current behaviour at any time:

```swift
    let current = AudioFeedbackPerformer<Never>.playbackBehavior
```

## Configuring Audio Settings

### Enabling audio effects

Audio effects are **disabled by default**. Enable them on app launch:

```swift
    @main
    struct MyApp: App {
        
        init() {
            UserDefaults.audio.set(true, for: AudioUserDefaultsKey.audioEffectsEnabled)
        }
        
        var body: some Scene {
            WindowGroup { ContentView() }
        }
    }
```

Or toggle it in response to a user action, such as a settings screen:

```swift
    Toggle("Sound Effects", isOn: $soundEnabled)
    .onChange(of: soundEnabled) { _, enabled in
        UserDefaults.audio.set(enabled, for: AudioUserDefaultsKey.audioEffectsEnabled)
    }
```

> [!IMPORTANT]
> The package only reads from the internal `.audio` `UserDefaults` suite. Settings written to `.standard` or any other suite are ignored.

### Available keys

| Key | Type | Default | Purpose |
| --- | --- | --- | --- |
| `audioEffectsEnabled` | `Bool` | `false` | Master on/off for all audio feedback |
| `audioPlaybackBehavior` | `Int` (raw value) | `0` (`.respectRinger`) | Controls how volume/ringer affects playback |

## Custom Audio

If the built-in system sounds are not sufficient, bring your own audio files using the `.custom(CustomSoundRepresentable)` playback case.

**Supported formats:** `.aif`, `.aiff`, `.caf`, `.mp3`, `.wav`
**Maximum duration:** 30 seconds

### 1. Define a conforming type

```swift
    enum MySound: CustomSoundRepresentable {
        case success
        case failure
        
        var soundFile: SoundFile {
            switch self {
                case .success: SoundFile(name: "success", extension: .caf)
                case .failure: SoundFile(name: "failure", extension: .caf)
            }
        }
    }
```

### 2. Add the files to your app target

Ensure the audio files are included in your app's main bundle.

### 3. Use in a view

```swift
    @State private var didSave = false
    
    Button("Save") { didSave.toggle() }
    .audioFeedback(.custom(MySound.success), trigger: didSave)
```

## Example App

The repository includes an iOS example app that demonstrates both playback behaviours side by side. Open `AudioManager.xcworkspace` to see the package sources and the example project together in one workspace.

```text
    AudioManager/
    ├── AudioManager.xcworkspace
    ├── Sources/AudioManager/
    └── Example/
    └── AudioManagerExample/
```

The example app has two sections:

- **Ringer Mode** — buttons that use `.respectRinger`. Flip the physical silent switch off and the sounds stop, regardless of the volume slider.
- **Volume Mode** — buttons that use `.respectVolume`. The silent switch is ignored; sounds play when the volume slider is above zero, and the buttons are disabled when it reaches zero.

> [!NOTE]
> Run the example on a **real device**. The simulator does not have a ringer switch, and volume KVO notifications do not fire reliably in the simulator.

### What is only in the example

`AudioSessionMonitor` is a KVO wrapper around `AVAudioSession.outputVolume` used to keep the volume progress bar in the example UI reactive. It is **not part of the library** and is not needed in a real app. The library reads `outputVolume` on demand at the moment `perform()` is called — no persistent observer is required.

## Contributing

Contributions are always welcome. Feel free to submit a pull request or open an issue for any suggestions or improvements.

## License

`AudioManager` is licensed under the MIT License. See the LICENCE file for more details.
