//
// Project: AudioManager — Example App
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import AudioManager
import SwiftUI

struct ContentView: View {

  @StateObject private var monitor = AudioSessionMonitor()

  // A representative set of sounds that are clearly audible and easy to distinguish.
  private struct SoundItem: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let sound: SystemSound
  }

  private let sounds: [SoundItem] = [
    SoundItem(name: "Received Message", icon: "message.fill", sound: .ui(.receivedMessage)),
    SoundItem(name: "Sent Message", icon: "paperplane.fill", sound: .ui(.sentMessage)),
    SoundItem(name: "New Mail", icon: "envelope.fill", sound: .ui(.newMail)),
    SoundItem(name: "Payment Success", icon: "checkmark.seal.fill", sound: .ui(.paymentSuccess)),
    SoundItem(name: "Photo Shutter", icon: "camera.fill", sound: .ui(.photoShutter)),
    SoundItem(name: "Alarm", icon: "alarm.fill", sound: .ui(.alarm)),
  ]

  var body: some View {
    NavigationStack {
      List {
        ringerSection
        volumeSection
      }
      .navigationTitle("AudioManager")
      .navigationBarTitleDisplayMode(.large)
    }
  }

  // MARK: - Ringer Mode

  private var ringerSection: some View {
    Section {
      ForEach(sounds) { item in
        Button {
          play(item.sound, behavior: .respectRinger)
        } label: {
          Label(item.name, systemImage: item.icon)
        }
      }
    } header: {
      Label("Ringer Mode", systemImage: "bell.fill")
    } footer: {
      Text(
        "Plays only when the ringer/silent switch is **on**. Volume level has no effect — the switch is the sole control."
      )
    }
  }

  // MARK: - Volume Mode

  private var volumeSection: some View {
    Section {
      volumeRow
      ForEach(sounds) { item in
        Button {
          play(item.sound, behavior: .respectVolume)
        } label: {
          Label(item.name, systemImage: item.icon)
        }
        .disabled(monitor.outputVolume == 0)
      }
    } header: {
      Label("Volume Mode", systemImage: "speaker.wave.3.fill")
    } footer: {
      if monitor.outputVolume == 0 {
        Text("Volume is at 0 — raise the volume to enable playback. The ringer switch is ignored.")
      } else {
        Text("Plays when device volume is above zero, **even if the ringer switch is off**.")
      }
    }
  }

  // MARK: - Volume Row

  private var volumeRow: some View {
    let muted = monitor.outputVolume == 0
    return HStack(spacing: 12) {
      Image(systemName: volumeIcon)
        .frame(width: 22)
        .foregroundStyle(muted ? Color.red : Color.secondary)

      ProgressView(value: Double(monitor.outputVolume))
        .tint(muted ? .red : .accentColor)

      Text("\(Int(monitor.outputVolume * 100))%")
        .font(.callout.monospacedDigit())
        .foregroundStyle(muted ? Color.red : Color.secondary)
        .frame(width: 44, alignment: .trailing)
    }
    .accessibilityLabel("Output volume: \(Int(monitor.outputVolume * 100)) percent")
  }

  // MARK: - Helpers

  private var volumeIcon: String {
    switch monitor.outputVolume {
    case 0: return "speaker.slash.fill"
    case ..<0.34: return "speaker.wave.1.fill"
    case ..<0.67: return "speaker.wave.2.fill"
    default: return "speaker.wave.3.fill"
    }
  }

  private func play(_ sound: SystemSound, behavior: AudioPlaybackBehavior) {
    UserDefaults.audio.set(behavior.rawValue, for: AudioUserDefaultsKey.audioPlaybackBehavior)
    AudioFeedbackPerformer<Int>.perform(.system(sound))
  }
}
