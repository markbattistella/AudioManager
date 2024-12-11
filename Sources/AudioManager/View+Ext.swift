//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI
import TriggerKit

// MARK: - Static Action

extension View {

    /// Adds audio feedback to a view for a static trigger without conditions.
    ///
    /// - Parameters:
    ///   - feedback: The audio feedback to be performed.
    ///   - trigger: The trigger value that, when changed, invokes the audio feedback.
    /// - Returns: A view modified to include audio feedback.
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

    /// Adds audio feedback to a view for a static trigger with a custom condition.
    ///
    /// - Parameters:
    ///   - feedback: The audio feedback to be performed.
    ///   - trigger: The trigger value that, when changed, invokes the audio feedback.
    ///   - condition: A closure that determines whether the feedback should be triggered, based
    ///   on the old and new values of the trigger.
    /// - Returns: A view modified to include audio feedback with the specified condition.
    public func audioFeedback<T: Equatable>(
        _ feedback: AudioFeedbackPerformer<T>.Playback,
        trigger: T,
        condition: @escaping (_ oldValue: T, _ newValue: T) -> Bool
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

    /// Adds audio feedback to a view for a static trigger with a simplified condition.
    ///
    /// - Parameters:
    ///   - feedback: The audio feedback to be performed.
    ///   - trigger: The trigger value that, when changed, invokes the audio feedback.
    ///   - condition: A closure that determines whether the feedback should be triggered, based
    ///   on the new value of the trigger.
    /// - Returns: A view modified to include audio feedback with the specified condition.
    public func audioFeedback<T: Equatable>(
        _ feedback: AudioFeedbackPerformer<T>.Playback,
        trigger: T,
        condition: @escaping (_ newValue: T) -> Bool
    ) -> some View {
        self.modifier(
            StateChangeModifier(
                feedback,
                trigger: trigger,
                condition: { _, newValue in
                    condition(newValue)
                },
                actionHandler: { feedback in
                    AudioFeedbackPerformer<T>.perform(feedback)
                }
            )
        )
    }

    /// Adds audio feedback to a view for a static trigger with a global condition.
    ///
    /// - Parameters:
    ///   - feedback: The audio feedback to be performed.
    ///   - trigger: The trigger value that, when changed, invokes the audio feedback.
    ///   - condition: A closure that determines whether the feedback should be triggered.
    /// - Returns: A view modified to include audio feedback with the specified condition.
    public func audioFeedback<T: Equatable>(
        _ feedback: AudioFeedbackPerformer<T>.Playback,
        trigger: T,
        condition: @escaping () -> Bool
    ) -> some View {
        self.modifier(
            StateChangeModifier(
                feedback,
                trigger: trigger,
                condition: { _, _ in condition() },
                actionHandler: { feedback in
                    AudioFeedbackPerformer<T>.perform(feedback)
                }
            )
        )
    }
}

// MARK: - Dynamic Action

extension View {

    /// Adds dynamic audio feedback to a view, with a custom feedback generator based on the old
    /// and new trigger values.
    ///
    /// - Parameters:
    ///   - trigger: The trigger value that, when changed, invokes the audio feedback.
    ///   - feedback: A closure that generates the audio feedback based on the old and new values
    ///   of the trigger.
    /// - Returns: A view modified to include dynamic audio feedback.
    public func audioFeedback<T: Equatable>(
        trigger: T,
        feedback: @escaping (_ oldValue: T, _ newValue: T) -> AudioFeedbackPerformer<T>.Playback?
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

    /// Adds dynamic audio feedback to a view, with a custom feedback generator based on the new
    /// trigger value.
    ///
    /// - Parameters:
    ///   - trigger: The trigger value that, when changed, invokes the audio feedback.
    ///   - feedback: A closure that generates the audio feedback based on the new value of the
    ///   trigger.
    /// - Returns: A view modified to include dynamic audio feedback.
    public func audioFeedback<T: Equatable>(
        trigger: T,
        feedback: @escaping (_ newValue: T) -> AudioFeedbackPerformer<T>.Playback?
    ) -> some View {
        self.modifier(
            StateChangeModifier(
                trigger: trigger,
                dynamicAction: { _, newValue in
                    feedback(newValue)
                },
                actionHandler: { feedback in
                    AudioFeedbackPerformer<T>.perform(feedback)
                }
            )
        )
    }

    /// Adds dynamic audio feedback to a view, with a global feedback generator.
    ///
    /// - Parameters:
    ///   - trigger: The trigger value that, when changed, invokes the audio feedback.
    ///   - feedback: A closure that generates the audio feedback regardless of the trigger values.
    /// - Returns: A view modified to include dynamic audio feedback.
    public func audioFeedback<T: Equatable>(
        trigger: T,
        feedback: @escaping () -> AudioFeedbackPerformer<T>.Playback?
    ) -> some View {
        self.modifier(
            StateChangeModifier(
                trigger: trigger,
                dynamicAction: { _, _ in feedback() },
                actionHandler: { feedback in
                    AudioFeedbackPerformer<T>.perform(feedback)
                }
            )
        )
    }
}
