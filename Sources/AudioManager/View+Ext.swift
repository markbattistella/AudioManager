//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI
import TriggerKit

// MARK: - Static Action

extension View {

    /// Adds an audio feedback effect that will be triggered when a state change occurs.
    ///
    /// This method is used to add a predefined `AudioFeedbackPerformer.Playback` feedback effect
    /// to a `View`.
    ///
    /// - Parameters:
    ///   - feedback: The type of audio feedback to be performed (e.g., system or custom).
    ///   - trigger: A trigger that will determine when the feedback should be performed. The
    ///   trigger must conform to `Equatable`.
    /// - Returns: The modified `View` that provides audio feedback based on the provided trigger.
    public func audioFeedback<T: Equatable>(
        _ feedback: AudioFeedbackPerformer<T>.Playback,
        trigger: T
    ) -> some View {
        self.modifier(
            StateChangeModifier(
                feedback,
                trigger: trigger,
                actionHandler: { feedback in
                    AudioFeedbackPerformer<T>.perform(feedback)
                }
            )
        )
    }
}

// MARK: - Static Action with Condition

extension View {

    /// Adds an audio feedback effect based on a state change with a specific condition.
    ///
    /// This method allows you to add an audio feedback effect to a `View`, which will be performed
    /// based on the evaluation of a condition between two states.
    ///
    /// - Parameters:
    ///   - feedback: The type of audio feedback to be performed (e.g., system or custom).
    ///   - trigger: A trigger that will determine when the feedback should be performed. The
    ///   trigger must conform to `Equatable`.
    ///   - condition: A closure that takes two parameters of type `T` and returns `true` if
    ///   feedback should be performed.
    /// - Returns: The modified `View` that provides audio feedback based on the provided trigger
    /// and condition.
    public func audioFeedback<T: Equatable>(
        _ feedback: AudioFeedbackPerformer<T>.Playback,
        trigger: T,
        condition: @escaping (T, T) -> Bool
    ) -> some View {
        self.modifier(
            StateChangeModifier(
                feedback,
                trigger: trigger,
                condition: condition,
                actionHandler: { feedback in
                    AudioFeedbackPerformer<T>.perform(feedback)
                }
            )
        )
    }
}

// MARK: - Dynamic Action

extension View {

    /// Adds an audio feedback effect dynamically determined by state changes.
    ///
    /// This method provides a dynamic way to determine the type of audio feedback to perform based
    /// on the comparison of two states.
    ///
    /// - Parameters:
    ///   - trigger: A trigger that will determine when the feedback should be performed. The
    ///   trigger must conform to `Equatable`.
    ///   - feedback: A closure that takes two parameters of type `T` and returns an optional
    ///   `AudioFeedbackPerformer.Playback`. If the result is non-`nil`, the specified audio
    ///   feedback will be performed.
    /// - Returns: The modified `View` that provides audio feedback dynamically based on the
    /// provided trigger and logic in the feedback closure.
    public func audioFeedback<T: Equatable>(
        trigger: T,
        feedback: @escaping (
            T, T
        ) -> AudioFeedbackPerformer<T>.Playback?
    ) -> some View {
        self.modifier(
            StateChangeModifier(
                trigger: trigger,
                dynamicAction: feedback,
                actionHandler: { feedback in
                    AudioFeedbackPerformer<T>.perform(feedback)
                }
            )
        )
    }
}
