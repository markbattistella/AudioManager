//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

extension SystemSound {
    
    /// Represents a collection of Nano system sounds used for playback.
    ///
    /// The `NanoSystemSound` enum defines a series of sound files specific to the Nano system
    /// environment, typically associated with small devices. These sounds are often used for
    /// haptic feedback, alerts, and notifications, enhancing the user experience by providing
    /// contextual sound cues.
    public enum NanoSystemSound: String, SystemSoundRepresentable {
        
        /// The folder name where the Nano system sounds are stored.
        internal var folderName: String { "nano/" }
        
        // MARK: - Nano System Sounds
        
        /// Represents a critical alert sound for third-party applications with haptic feedback.
        case thirdPartyCriticalHaptic = "3rd_Party_Critical_Haptic.caf"
        
        /// Represents a haptic alert indicating a directional down movement for third-party apps.
        case thirdPartyDirectionDownHaptic = "3rdParty_DirectionDown_Haptic.caf"
        
        /// Represents a haptic alert indicating a directional up movement for third-party apps.
        case thirdPartyDirectionUpHaptic = "3rdParty_DirectionUp_Haptic.caf"
        
        /// Represents a haptic sound indicating failure for a third-party action.
        case thirdPartyFailureHaptic = "3rdParty_Failure_Haptic.caf"
        
        /// Represents a haptic sound indicating a retry action for a third-party application.
        case thirdPartyRetryHaptic = "3rdParty_Retry_Haptic.caf"
        
        /// Represents a haptic feedback sound indicating the start of an action in a third-party
        /// application.
        case thirdPartyStartHaptic = "3rdParty_Start_Haptic.caf"
        
        /// Represents a haptic feedback sound indicating the stop of an action in a third-party
        /// application.
        case thirdPartyStopHaptic = "3rdParty_Stop_Haptic.caf"
        
        /// Represents a haptic sound indicating success for a third-party action.
        case thirdPartySuccessHaptic = "3rdParty_Success_Haptic.caf"
        
        /// Represents the sound played when an access scan is completed, with accompanying
        /// haptic feedback.
        case accessScanCompleteHaptic = "AccessScanComplete_Haptic.caf"
        
        /// Represents an alarm sound with haptic feedback.
        case alarmHaptic = "Alarm_Haptic.caf"
        
        /// Represents an alarm sound used for nightstand mode, with haptic feedback.
        case alarmNightstandHaptic = "Alarm_Nightstand_Haptic.caf"
        
        /// Represents an alert sound for first-party apps with haptic feedback.
        case alertFirstPartyHaptic = "Alert_1stParty_Haptic.caf"
        
        /// Represents an alert sound for third-party apps with haptic feedback.
        case alertThirdPartyHaptic = "Alert_3rdParty_Haptic.caf"
        
        /// Represents a salient alert for third-party apps, including prominent haptic feedback.
        case alertThirdPartySalientHaptic = "Alert_3rdParty_Salient_Haptic.caf"
        
        /// Represents a haptic alert when a friend’s activity goal is attained.
        case alertActivityFriendsGoalAttainedHaptic = "Alert_ActivityFriendsGoalAttained_Haptic.caf"
        
        /// Represents a haptic alert when an activity goal is attained.
        case alertActivityGoalAttainedHaptic = "Alert_ActivityGoalAttained_Haptic.caf"
        
        /// Represents a salient alert for an activity goal attained, including prominent haptic
        /// feedback.
        case alertActivityGoalAttainedSalientHaptic = "Alert_ActivityGoalAttained_Salient_Haptic.caf"
        
        /// Represents a haptic alert indicating that an activity goal is behind schedule.
        case alertActivityGoalBehindHaptic = "Alert_ActivityGoalBehind_Haptic.caf"
        
        /// Represents a salient alert indicating that an activity goal is behind schedule, with
        /// more prominent haptic feedback.
        case alertActivityGoalBehindSalientHaptic = "Alert_ActivityGoalBehind_Salient_Haptic.caf"
        
        /// Represents a haptic alert indicating that an activity goal is close to being attained.
        case alertActivityGoalCloseHaptic = "Alert_ActivityGoalClose_Haptic.caf"
        
        /// Represents an alert indicating that the battery level is low (10%), with accompanying
        /// haptic feedback.
        case alertBatteryLow10pHaptic = "Alert_BatteryLow_10p_Haptic.caf"
        
        /// Represents an alert indicating that the battery level is low (5%), with accompanying
        /// haptic feedback.
        case alertBatteryLow5pHaptic = "Alert_BatteryLow_5p_Haptic.caf"
        
        /// Represents a salient alert indicating that the battery level is low (5%), including
        /// prominent haptic feedback.
        case alertBatteryLow5pSalientHaptic = "Alert_BatteryLow_5p_Salient_Haptic.caf"
        
        /// Represents an alert for a calendar event, with accompanying haptic feedback.
        case alertCalendarHaptic = "Alert_Calendar_Haptic.caf"
        
        /// Represents a salient alert for a calendar event, including prominent haptic feedback.
        case alertCalendarSalientHaptic = "Alert_Calendar_Salient_Haptic.caf"
        
        /// Represents a haptic alert related to a health notification.
        case alertHealthHaptic = "Alert_Health_Haptic.caf"
        
        /// Represents an alert with haptic feedback for directions given in the Maps application.
        case alertMapsDirectionsInAppHaptic = "Alert_MapsDirectionsInApp_Haptic.caf"
        
        /// Represents an alert related to a Passbook balance, with accompanying haptic feedback.
        case alertPassbookBalanceHaptic = "Alert_PassbookBalance_Haptic.caf"
        
        /// Represents an alert for a Passbook geofence event, with accompanying haptic feedback.
        case alertPassbookGeofenceHaptic = "Alert_PassbookGeofence_Haptic.caf"
        
        /// Represents a salient alert for a Passbook geofence event, with more prominent haptic
        /// feedback.
        case alertPassbookGeofenceSalientHaptic = "Alert_PassbookGeofence_Salient_Haptic.caf"
        
        /// Represents an alert for new activity in the Photo Stream, with accompanying haptic
        /// feedback.
        case alertPhotoStreamActivityHaptic = "Alert_PhotostreamActivity_Haptic.caf"
        
        /// Represents a haptic alert for a due reminder.
        case alertReminderDueHaptic = "Alert_ReminderDue_Haptic.caf"
        
        /// Represents a salient haptic alert for a due reminder, with more prominent feedback.
        case alertReminderDueSalientHaptic = "Alert_ReminderDue_Salient_Haptic.caf"
        
        /// Represents an alert indicating that Spartan is connected with low latency, including
        /// haptic feedback.
        case alertSpartanConnectedLowLatencyHaptic = "Alert_SpartanConnected_LowLatency_Haptic.caf"
        
        /// Represents an alert indicating that Spartan is connecting, with accompanying haptic
        /// feedback.
        case alertSpartanConnectingHaptic = "Alert_SpartanConnecting_Haptic.caf"
        
        /// Represents an alert indicating that Spartan is connecting with low latency, with
        /// accompanying haptic feedback.
        case alertSpartanConnectingLowLatencyHaptic = "Alert_SpartanConnecting_LowLatency_Haptic.caf"
        
        /// Represents an alert indicating that Spartan has disconnected with low latency,
        /// including haptic feedback.
        case alertSpartanDisconnectedLowLatencyHaptic = "Alert_SpartanDisconnected_LowLatency_Haptic.caf"
        
        /// Represents a voicemail alert with accompanying haptic feedback.
        case alertVoiceMailHaptic = "Alert_Voicemail_Haptic.caf"
        
        /// Represents a salient voicemail alert with prominent haptic feedback.
        case alertVoiceMailSalientHaptic = "Alert_Voicemail_Salient_Haptic.caf"
        
        /// Represents a haptic alert for the Walkie-Talkie feature.
        case alertWalkieTalkieHaptic = "Alert_WalkieTalkie_Haptic.caf"
        
        /// Represents a haptic feedback sound indicating an auto-unlock event.
        case autoUnlockHaptic = "AutoUnlock_Haptic.caf"
        
        /// Represents a haptic alert related to connecting to MagSafe power.
        case batteryMagSafeHaptic = "BatteryMagsafe_Haptic.caf"
        
        /// Represents a simple beat haptic feedback.
        case beatHaptic = "Beat_Haptic.caf"
        
        /// Represents a haptic alert indicating the start of buddy migration.
        case buddyMigrationStartHaptic = "BuddyMigrationStart_Haptic.caf"
        
        /// Represents a haptic alert for a buddy pairing failure event.
        case buddyPairingFailureHaptic = "BuddyPairingFailure_Haptic.caf"
        
        /// Represents a haptic feedback indicating a remote connection during buddy pairing.
        case buddyPairingRemoteConnectionHaptic = "BuddyPairingRemoteConnection_Haptic.caf"
        
        /// Represents a haptic feedback during a remote tap event in buddy pairing.
        case buddyPairingRemoteTapHaptic = "BuddyPairingRemoteTap_Haptic.caf"
        
        /// Represents a haptic alert indicating a successful buddy pairing.
        case buddyPairingSuccessHaptic = "BuddyPairingSuccess_Haptic.caf"
        
        /// Represents a busy tone (ANSI standard).
        case busyToneAnsi = "busy_tone_ansi.caf"
        
        /// Represents a busy tone (CEPT standard).
        case busyToneCept = "busy_tone_cept.caf"
        
        /// Represents the call waiting tone (ANSI standard).
        case callWaitingToneAnsi = "call_waiting_tone_ansi.caf"
        
        /// Represents the call waiting tone (CEPT standard).
        case callWaitingToneCept = "call_waiting_tone_cept.caf"
        
        /// Represents a haptic feedback indicating an imminent camera countdown.
        case cameraCountdownImminentHaptic = "CameraCountdownImminent_Haptic.caf"
        
        /// Represents a haptic feedback for each tick during a camera countdown.
        case cameraCountdownTickHaptic = "CameraCountdownTick_Haptic.caf"
        
        /// Represents the camera shutter sound with haptic feedback.
        case cameraShutterHaptic = "CameraShutter_Haptic.caf"
        
        /// Represents the call waiting tone for CT.
        case ctCallWaiting = "ct-call-waiting.caf"
        
        /// Represents a detent haptic feedback used to indicate reaching a point of adjustment
        /// or selection.
        case detentHaptic = "Detent_Haptic.caf"
        
        /// Represents a haptic alert for activating Do Not Disturb mode.
        case doNotDisturbHaptic = "DoNotDisturb_Haptic.caf"
        
        /// Represents the Dual Tone Multi Frequency (DTMF) sound for the digit '0'.
        case dtmf0 = "dtmf-0.caf"
        
        /// Represents the Dual Tone Multi Frequency (DTMF) sound for the digit '1'.
        case dtmf1 = "dtmf-1.caf"
        
        /// Represents the Dual Tone Multi Frequency (DTMF) sound for the digit '2'.
        case dtmf2 = "dtmf-2.caf"
        
        /// Represents the Dual Tone Multi Frequency (DTMF) sound for the digit '3'.
        case dtmf3 = "dtmf-3.caf"
        
        /// Represents the Dual Tone Multi Frequency (DTMF) sound for the digit '4'.
        case dtmf4 = "dtmf-4.caf"
        
        /// Represents the Dual Tone Multi Frequency (DTMF) sound for the digit '5'.
        case dtmf5 = "dtmf-5.caf"
        
        /// Represents the Dual Tone Multi Frequency (DTMF) sound for the digit '6'.
        case dtmf6 = "dtmf-6.caf"
        
        /// Represents the Dual Tone Multi Frequency (DTMF) sound for the digit '7'.
        case dtmf7 = "dtmf-7.caf"
        
        /// Represents the Dual Tone Multi Frequency (DTMF) sound for the digit '8'.
        case dtmf8 = "dtmf-8.caf"
        
        /// Represents the Dual Tone Multi Frequency (DTMF) sound for the digit '9'.
        case dtmf9 = "dtmf-9.caf"
        
        /// Represents the Dual Tone Multi Frequency (DTMF) sound for the pound key.
        case dtmfPound = "dtmf-pound.caf"
        
        /// Represents the Dual Tone Multi Frequency (DTMF) sound for the star key.
        case dtmfStar = "dtmf-star.caf"
        
        /// Represents the end call tone (CEPT standard).
        case endCallToneCept = "end_call_tone_cept.caf"
        
        /// Represents the haptic feedback for beginning an ET notification.
        case etBeginNotificationHaptic = "ET_BeginNotification_Haptic.caf"
        
        /// Represents a salient haptic feedback for beginning an ET notification.
        case etBeginNotificationSalientHaptic = "ET_BeginNotification_Salient_Haptic.caf"
        
        /// Represents a haptic feedback for receiving an ET remote tap.
        case etRemoteTapReceiveHaptic = "ET_RemoteTap_Receive_Haptic.caf"
        
        /// Represents a haptic feedback for sending an ET remote tap.
        case etRemoteTapSendHaptic = "ET_RemoteTap_Send_Haptic.caf"
        
        /// Represents a haptic feedback for going to sleep.
        case goToSleepHaptic = "GoToSleep_Haptic.caf"
        
        /// Represents the sound played when the headphone audio exposure limit is exceeded.
        case headphoneAudioExposureLimitExceeded = "HeadphoneAudioExposureLimitExceeded.caf"
        
        /// Represents an urgent health-related notification.
        case healthNotificationUrgent = "HealthNotificationUrgent.caf"
        
        /// Represents a haptic feedback indicating a successful health reading completion.
        case healthReadingCompleteHaptic = "HealthReadingComplete_Haptic.caf"
        
        /// Represents a haptic feedback indicating a failure during a health reading.
        case healthReadingFailHaptic = "HealthReadingFail_Haptic.caf"
        
        /// Represents the haptic feedback for an hourly chime.
        case hourlyChimeHaptic = "HourlyChime_Haptic.caf"
        
        /// Represents a haptic feedback indicating a successful "Hummingbird" completion.
        case hummingbirdCompletionHaptic = "HummingbirdCompletion_Haptic.caf"
        
        /// Represents a haptic notification related to the "Hummingbird" feature.
        case hummingbirdNotificationHaptic = "HummingbirdNotification_Haptic.caf"
        
        /// Represents the sound for beginning a JBL action.
        case jblBegin = "jbl_begin.caf"
        
        /// Represents the sound for canceling a JBL action.
        case jblCancel = "jbl_cancel.caf"
        
        /// Represents the confirmation sound for a JBL action.
        case jblConfirm = "jbl_confirm.caf"
        
        /// Represents a haptic feedback for an incoming message.
        case messagesIncomingHaptic = "MessagesIncoming_Haptic.caf"
        
        /// Represents a haptic feedback for an outgoing message.
        case messagesOutgoingHaptic = "MessagesOutgoing_Haptic.caf"
        
        /// Represents the sound played when a multiway invitation is received.
        case multiwayInvitation = "MultiwayInvitation.caf"
        
        /// Represents the sound played when joining a multiway conversation.
        case multiwayJoin = "MultiwayJoin.caf"
        
        /// Represents the sound played when leaving a multiway conversation.
        case multiwayLeave = "MultiwayLeave.caf"
        
        /// Represents a haptic feedback for a generic navigational maneuver.
        case navigationGenericManeuverHaptic = "NavigationGenericManeuver_Haptic.caf"
        
        /// Represents a salient haptic feedback for a generic navigational maneuver.
        case navigationGenericManeuverSalientHaptic = "NavigationGenericManeuver_Salient_Haptic.caf"
        
        /// Represents a haptic feedback for a left turn navigational maneuver.
        case navigationLeftTurnHaptic = "NavigationLeftTurn_Haptic.caf"
        
        /// Represents a salient haptic feedback for a left turn navigational maneuver.
        case navigationLeftTurnSalientHaptic = "NavigationLeftTurn_Salient_Haptic.caf"
        
        /// Represents a haptic feedback for a right turn navigational maneuver.
        case navigationRightTurnHaptic = "NavigationRightTurn_Haptic.caf"
        
        /// Represents a salient haptic feedback for a right turn navigational maneuver.
        case navigationRightTurnSalientHaptic = "NavigationRightTurn_Salient_Haptic.caf"
        
        /// Represents a haptic feedback for a general notification.
        case notificationHaptic = "Notification_Haptic.caf"
        
        /// Represents a salient haptic feedback for a notification, providing more prominent feedback.
        case notificationSalientHaptic = "Notification_Salient_Haptic.caf"
        
        /// Represents a haptic feedback indicating a failed on/off passcode attempt.
        case onOffPasscodeFailureHaptic = "OnOffPasscodeFailure_Haptic.caf"
        
        /// Represents a haptic feedback indicating the successful unlocking of an on/off passcode.
        case onOffPasscodeUnlockHaptic = "OnOffPasscodeUnlock_Haptic.caf"
        
        /// Represents a haptic feedback for successfully unlocking a companion device with an
        /// on/off passcode.
        case onOffPasscodeUnlockCompanionHaptic = "OnOffPasscodeUnlockCampanion_Haptic.caf"
        
        /// Represents a haptic feedback for the "Orb Exit" interaction.
        case orbExitHaptic = "OrbExit_Haptic.caf"
        
        /// Represents a haptic feedback for interacting with "Orb Layers".
        case orbLayersHaptic = "OrbLayers_Haptic.caf"
        
        /// Represents a haptic feedback for answering a phone call.
        case phoneAnswerHaptic = "PhoneAnswer_Haptic.caf"
        
        /// Represents a haptic feedback for hanging up a phone call.
        case phoneHangUpHaptic = "PhoneHangUp_Haptic.caf"
        
        /// Represents a haptic feedback for placing a call on hold.
        case phoneHoldHaptic = "PhoneHold_Haptic.caf"
        
        /// Represents a haptic feedback for a zoom detent when using the Photos app.
        case photosZoomDetentHaptic = "PhotosZoomDetent_Haptic.caf"
        
        /// Represents a preview that includes both audio and haptic feedback.
        case previewAudioAndHaptic = "Preview_AudioAndHaptic.caf"
        
        /// Represents a haptic feedback used during QuickBoard (QB) dictation.
        case qbDictationHaptic = "QB_Dictation_Haptic.caf"
        
        /// Represents a haptic feedback indicating that QuickBoard (QB) dictation has been
        /// turned off.
        case qbDictationOffHaptic = "QB_Dictation_Off_Haptic.caf"
        
        /// Represents a haptic feedback for the beginning of a remote camera shutter burst.
        case remoteCameraShutterBurstBeginHaptic = "RemoteCameraShutterBurstBegin_Haptic.caf"
        
        /// Represents a haptic feedback for the end of a remote camera shutter burst.
        case remoteCameraShutterBurstEndHaptic = "RemoteCameraShutterBurstEnd_Haptic.caf"
        
        /// Represents the ringback tone (ANSI standard).
        case ringbackToneAnsi = "ringback_tone_ansi.caf"
        
        /// Represents the ringback tone for Australia (AUS standard).
        case ringbackToneAus = "ringback_tone_aus.caf"
        
        /// Represents the ringback tone (CEPT standard).
        case ringbackToneCept = "ringback_tone_cept.caf"
        
        /// Represents the ringback tone for Hong Kong.
        case ringbackToneHk = "ringback_tone_hk.caf"
        
        /// Represents the ringback tone for the United Kingdom (UK).
        case ringbackToneUk = "ringback_tone_uk.caf"
        
        /// Represents a ringtone with two segments, combined with a ducked haptic, named "sashimi".
        case ringtoneTwoDuckedHapticSashimi = "Ringtone_2_Ducked_Haptic-sashimi.caf"
        
        /// Represents a ringtone with two segments, including haptic feedback, named "sashimi".
        case ringtoneTwoHapticSashimi = "Ringtone_2_Haptic-sashimi.caf"
        
        /// Represents a ringtone for the United Kingdom (UK) with haptic feedback.
        case ringtoneUkHaptic = "Ringtone_UK_Haptic.caf"
        
        /// Represents a ringtone for the United States (US) with haptic feedback.
        case ringtoneUsHaptic = "Ringtone_US_Haptic.caf"
        
        /// Represents a ringtone for the United Kingdom (UK) with ducked haptic feedback.
        case ringtoneDuckedUkHaptic = "RingtoneDucked_UK_Haptic.caf"
        
        /// Represents a ringtone for the United States (US) with ducked haptic feedback.
        case ringtoneDuckedUsHaptic = "RingtoneDucked_US_Haptic.caf"
        
        /// Represents a salient haptic feedback for an important notification.
        case salientNotificationHaptic = "SalientNotification_Haptic.caf"
        
        /// Represents the sound played when a screen capture is taken.
        case screenCapture = "ScreenCapture.caf"
        
        /// Represents a haptic feedback for a sedentary timer notification.
        case sedentaryTimerHaptic = "SedentaryTimer_Haptic.caf"
        
        /// Represents a salient haptic feedback for a sedentary timer notification, with more
        /// prominent feedback.
        case sedentaryTimerSalientHaptic = "SedentaryTimer_Salient_Haptic.caf"
        
        /// Represents a haptic feedback used when Siri auto-sends information.
        case siriAutoSendHaptic = "SiriAutoSend_Haptic.caf"
        
        /// Represents a haptic feedback for starting Siri.
        case siriStartHaptic = "SiriStart_Haptic.caf"
        
        /// Represents a haptic feedback for an unsuccessful Siri stop attempt.
        case siriStopFailureHaptic = "SiriStopFailure_Haptic.caf"
        
        /// Represents a haptic feedback for a successful Siri stop action.
        case siriStopSuccessHaptic = "SiriStopSuccess_Haptic.caf"
        
        /// Represents the sound played when an SMS is received (variation 1).
        case smsReceived1 = "sms-received1.caf"
        
        /// Represents a haptic feedback for an SOS emergency contact text prompt.
        case sosEmergencyContactTextPromptHaptic = "SOSEmergencyContactTextPrompt_Haptic.caf"
        
        /// Represents a haptic feedback for an SOS fall detection prompt.
        case sosFallDetectionPromptHaptic = "SOSFallDetectionPrompt_Haptic.caf"
        
        /// Represents an escalated haptic feedback for an SOS fall detection prompt.
        case sosFallDetectionPromptEscalationHaptic = "SOSFallDetectionPromptEscalation_Haptic.caf"
    }
}
