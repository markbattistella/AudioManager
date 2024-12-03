<!-- markdownlint-disable MD033 MD041 -->
<div align="center">

# AudioManager

![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FAudioManager%2Fbadge%3Ftype%3Dswift-versions)

![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FAudioManager%2Fbadge%3Ftype%3Dplatforms)

![Licence](https://img.shields.io/badge/Licence-MIT-white?labelColor=blue&style=flat)

</div>

`AudioManager` is a Swift package that provides a modular and easy-to-use interface for implementing audio feedback in your applications. It integrates seamlessly with SwiftUI, enabling you to enhance user experience through customisable audible feedback.

## Features

- **Custom Audio:** Easily define and trigger audio feedback.
- **SwiftUI Extensions:** Add audio feedback to SwiftUI views in a declarative way.
- **User Preferences:** Enable or disable audio feedback based on user settings through simple configuration.
- **Custom Audio Patterns:** Extend and create your own audio feedback.

## Installation

Add `AudioManager` to your Swift project using Swift Package Manager.

```swift
dependencies: [
  .package(url: "https://github.com/markbattistella/AudioManager", from: "1.0.0")
]
```

## Usage

There are three type of ways to use the `AudioManager`:

- **Static Action:** This is the simplest method, used when you want to trigger audio feedback for a particular state change. It's consistent and straightforward — ideal when the audio feedback needs to occur every time a specific condition (like a state variable changing) is met.
- **Static Action with Condition:** This approach adds more control compared to the standard static action. Here, you specify a set of conditions to determine when the audio feedback should be triggered. This allows you to handle more nuanced scenarios — such as only playing feedback when transitioning from one specific state to another, while ignoring others.
- **Dynamic Action:** The most flexible of the three, dynamic actions let you determine the type of audio feedback based on the old and new values during a state change. This means you can implement complex feedback behaviours that respond differently based on how the state transitions, allowing for a more dynamic and tailored user experience.

> [!NOTE]  
> Though there is the `.system()` `Playback` call, it is only available on iOS as that is where those in-build sounds live. All other uses can utilise the `.custom()` option.

### Static Action

The static action format allows you to trigger audio feedback consistently and simply. In the example below, audio feedback is triggered whenever the `isSuccess` state changes.

```swift
@State private var isSuccess: Bool = false

Button("isSuccess: \(isSuccess)") {
  isSuccess.toggle()
}
.audioFeedback(.system(.ui(.tock)), trigger: isSuccess)
```

### Static Action with Condition

You can also use a condition to control when the audio feedback should be triggered, allowing for more focused control over when feedback occurs.

```swift
enum Phase { case inactive, active, completed }

@State private var phase: Phase = .inactive

Button("Update phase") {
  switch phase {
    case .inactive: phase = .active
    case .active: phase = .completed
    case .completed: phase = .inactive
  }
}
.audioFeedback(.system(.ui(.tink)), trigger: phase) { oldValue, newValue in
  oldValue != .completed && newValue == .completed
}
```

### Dynamic Action

The dynamic action approach gives you full control over both the type of feedback and the conditions under which it's triggered.

```swift
enum LoadingState { case ready, success, failure }

@State private var loadingState: LoadingState = .ready

Button("Update loading state") {
  switch loadingState {
    case .ready: loadingState = .success
    case .success: loadingState = .failure
    case .failure: loadingState = .ready
  }
}
.audioFeedback(trigger: loadingState) { oldValue, newValue in
  switch (oldValue, newValue) {
    case (.failure, .ready):
      return .system(.modern(.cameraShutterBurstBegin))
    case (.ready, .success):
      return .system(.nano(.screenCapture))
    case (.success, .failure):
      return .system(.new(.update))
    default:
      return nil
  }
}
```

### Configuring Audio Settings

`AudioManager` includes a `.audioEffectsEnabled` `UserDefaults` key, allowing you to dynamically enable or disable audio based on user settings.

This is helpful if you want to add a settings screen for toggling audio sound effects, or if you need an overall logic to control audio — for example, making it a premium feature.

#### Built-in UserDefaults Suite

The package uses an internal, publicly exposed `UserDefaults` suite for storing audio-related settings:

```swift
@main
struct MyAwesomeApp: App {

  init() {
    UserDefaults.audio.register([
      AudioUserDefaultsKey.audioEffectsEnabled : true
    ])
  }

  var body: some Scene {
    WindowGroup { ... }
  }
}
```

Or manually updating it:

```swift
Button("Turn audio off") {
  UserDefaults.audio.set(false, for: AudioUserDefaultKeys.isAudioEnabled)
}

Button("Turn audio on") {
  UserDefaults.audio.set(true, for: AudioUserDefaultKeys.isAudioEnabled)
}
```

> [!IMPORTANT]  
> Although you can register `UserDefaults` to any suite (`.standard` or custom), the package will only respond to the internal `.audio` suite to prevent unintended clashes across different parts of the application.

## Extending Audio Feedback Types

If the built-in feedback types are not sufficient, you can use your own custom audio files using the `.custom(CustomSoundRepresentable)` `Playback` case.

### Custom File Restrictions

There are a limited accepted audio file extensions allowed: `.aif`, `.aiff`, `.caf`, `.mp3`, and `.wav`.

Also your audio file is limited to `30` seconds. The playback will simply not occur if it is longer than 30 seconds.

### Creating a Custom Feedback

To add a custom audio feedback type:

1. Define a `CustomSoundRepresentable` conforming enum:

```swift
enum MyCustomSound: CustomSoundRepresentable {
    case tupperwareFallingOutOfCrampedCupboard

    var soundFile: SoundFile {
        switch self {
            case .tupperwareFallingOutOfCrampedCupboard:
              Soundfile(name: "tupperwareFallingOutOfCrampedCupboard", extension: .aif)
        }
    }
}
```

2. Ensure that the filename and extension are correct, and loaded into your app main bundle.

3. Use the custom feedback in your app:

```swift
@State private var isError: Bool = false

Button("Show error") {
  isError.toggle()
}
.audioFeedback(.custom(MyCustomSound.tupperwareFallingOutOfCrampedCupboard), trigger: isError)
```

## Contributing

Contributions are always welcome! Feel free to submit a pull request or open an issue for any suggestions or improvements you have.

## License

`AudioManager` is licensed under the MIT License. See the LICENCE file for more details.
