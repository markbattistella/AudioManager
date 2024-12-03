//
// Project: AudioManager
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

extension SystemSound {

    /// Represents a collection of UI-related system sounds available for playback.
    ///
    /// The `UISystemSound` enum defines a variety of sounds commonly used in user interface
    /// feedback, such as notifications, alerts, and keyboard presses. These sounds enhance the
    /// user experience by providing auditory feedback for different interactions within the
    /// application.
    public enum UISystemSound: String, SystemSoundRepresentable {

        /// The folder name where the UI system sounds are stored.
        internal var folderName: String { "" }

        // MARK: - UI System Sounds

        /// Represents a critical alert sound for third-party apps.
        case thirdPartyCritical = "3rd_party_critical.caf"

        /// Represents the sound played when an access scan is completed.
        case accessScanComplete = "access_scan_complete.caf"

        /// Represents the sound played when an acknowledgment is received.
        case acknowledgmentReceived = "acknowledgment_received.caf"

        /// Represents the sound played when an acknowledgment is sent.
        case acknowledgmentSent = "acknowledgment_sent.caf"

        /// Represents an alarm sound.
        case alarm = "alarm.caf"

        /// Represents the sound played when recording begins.
        case beginRecord = "begin_record.caf"

        /// Represents the camera timer countdown sound.
        case cameraTimerCountdown = "camera_timer_countdown.caf"

        /// Represents the sound played during the final second of the camera timer countdown.
        case cameraTimerFinalSecond = "camera_timer_final_second.caf"

        /// Represents the sound played when power is connected to the device.
        case connectPower = "connect_power.caf"

        /// Represents the "busy" call tone.
        case ctBusy = "ct-busy.caf"

        /// Represents the sound played when a call is congested.
        case ctCongestion = "ct-congestion.caf"

        /// Represents an error tone for calls.
        case ctError = "ct-error.caf"

        /// Represents a key tone for calls.
        case ctKeytone2 = "ct-keytone2.caf"

        /// Represents the call path acknowledgment sound.
        case ctPathAck = "ct-path-ack.caf"

        /// Represents the sound played when recording ends.
        case endRecord = "end_record.caf"

        /// Represents the sound played when the app icon is changed in focus.
        case focusChangeAppIcon = "focus_change_app_icon.caf"

        /// Represents the sound played when focus changes to a keyboard.
        case focusChangeKeyboard = "focus_change_keyboard.caf"

        /// Represents the sound for a large focus change (e.g., moving to a significantly
        /// different UI element).
        case focusChangeLarge = "focus_change_large.caf"

        /// Represents the sound for a small focus change (e.g., slight navigation within the
        /// same component).
        case focusChangeSmall = "focus_change_small.caf"

        /// Represents an alert sound for going to sleep.
        case goToSleepAlert = "go_to_sleep_alert.caf"

        /// Represents a notification sound for health-related updates.
        case healthNotification = "health_notification.caf"

        /// Represents an ambiguous JBL sound.
        case jblAmbiguous = "jbl_ambiguous.caf"

        /// Represents the sound played at the beginning of a JBL interaction.
        case jblBegin = "jbl_begin.caf"

        /// Represents the JBL cancel sound.
        case jblCancel = "jbl_cancel.caf"

        /// Represents the JBL confirmation sound.
        case jblConfirm = "jbl_confirm.caf"

        /// Represents the JBL "no match" sound.
        case jblNoMatch = "jbl_no_match.caf"

        /// Represents the sound played when a key is pressed.
        case keyPressClick = "key_press_click.caf"

        /// Represents the sound played when a delete key is pressed.
        case keyPressDelete = "key_press_delete.caf"

        /// Represents the sound played when a modifier key (e.g., Shift or Control) is pressed.
        case keyPressModifier = "key_press_modifier.caf"

        /// Represents the sound for clearing keyboard text.
        case keyboardPressClear = "keyboard_press_clear.caf"

        /// Represents the sound for deleting keyboard text.
        case keyboardPressDelete = "keyboard_press_delete.caf"

        /// Represents the normal sound for pressing a keyboard key.
        case keyboardPressNormal = "keyboard_press_normal.caf"

        /// Represents the sound played when the device is locked.
        case lock = "lock.caf"

        /// Represents a sound with a long low tone followed by a short high tone.
        case longLowShortHigh = "long_low_short_high.caf"

        /// Represents the sound indicating low power status.
        case lowPower = "low_power.caf"

        /// Represents the sound played when mail is sent.
        case mailSent = "mail-sent.caf"

        /// Represents a middle-pitched, short, double low tone.
        case middleNineShortDoubleLow = "middle_9_short_double_low.caf"

        /// Represents the sound played when an invitation is made for a multiway call.
        case multiwayInvitation = "multiway_invitation.caf"

        /// Represents the sound played when navigating backwards in a UI stack.
        case navigationPop = "navigation_pop.caf"

        /// Represents the sound played when navigating forwards in a UI stack.
        case navigationPush = "navigation_push.caf"

        /// Represents the sound played when new mail is received.
        case newMail = "new-mail.caf"

        /// Represents the sound played when an NFC scan is completed successfully.
        case nfcScanComplete = "nfc_scan_complete.caf"

        /// Represents the sound played when an NFC scan fails.
        case nfcScanFailure = "nfc_scan_failure.caf"

        /// Represents the sound played when a payment fails.
        case paymentFailure = "payment_failure.caf"

        /// Represents the sound played when a payment is successful.
        case paymentSuccess = "payment_success.caf"

        /// Represents the sound played for the camera photo shutter.
        case photoShutter = "photoShutter.caf"

        /// Represents the sound played when a message is received.
        case receivedMessage = "ReceivedMessage.caf"

        /// Represents the sound indicating a change in ringer status.
        case ringerChanged = "RingerChanged.caf"

        /// Represents the sound played when a message is sent.
        case sentMessage = "SentMessage.caf"

        /// Represents the sound played when the device is shaken.
        case shake = "shake.caf"

        /// Represents a short, double high-pitched tone.
        case shortDoubleHigh = "short_double_high.caf"

        /// Represents a short, double low-pitched tone.
        case shortDoubleLow = "short_double_low.caf"

        /// Represents a short sound that transitions from low to high pitch.
        case shortLowHigh = "short_low_high.caf"

        /// Represents the sound played when a SIM toolkit call is dropped.
        case simToolkitCallDropped = "SIMToolkitCallDropped.caf"

        /// Represents a general beep from the SIM toolkit.
        case simToolkitGeneralBeep = "SIMToolkitGeneralBeep.caf"

        /// Represents a negative acknowledgment beep from the SIM toolkit.
        case simToolkitNegativeAck = "SIMToolkitNegativeACK.caf"

        /// Represents a positive acknowledgment beep from the SIM toolkit.
        case simToolkitPositiveAck = "SIMToolkitPositiveACK.caf"

        /// Represents the sound played when an SMS is received through the SIM toolkit.
        case simToolkitSms = "SIMToolkitSMS.caf"

        /// Represents the sound played when an SMS is received (variation 1).
        case smsReceived1 = "sms-received1.caf"

        /// Represents the sound played when an SMS is received (variation 2).
        case smsReceived2 = "sms-received2.caf"

        /// Represents the sound played when an SMS is received (variation 3).
        case smsReceived3 = "sms-received3.caf"

        /// Represents the sound played when an SMS is received (variation 4).
        case smsReceived4 = "sms-received4.caf"

        /// Represents the sound played when an SMS is received (variation 5).
        case smsReceived5 = "sms-received5.caf"

        /// Represents the sound played when an SMS is received (variation 6).
        case smsReceived6 = "sms-received6.caf"

        /// Represents a swish sound effect.
        case swish = "Swish.caf"

        /// Represents a "tink" sound effect.
        case tink = "Tink.caf"

        /// Represents a "tock" sound effect.
        case tock = "Tock.caf"

        /// Represents the sound played when a tweet is sent.
        case tweetSent = "tweet_sent.caf"

        /// Represents the sound played when a USSD (Unstructured Supplementary Service Data)
        /// notification is received.
        case ussd = "ussd.caf"

        /// Represents the sound titled "warsaw".
        case warsaw = "warsaw.caf"

        /// Represents the "wheels of time" sound effect.
        case wheelsOfTime = "wheels_of_time.caf"
    }
}
