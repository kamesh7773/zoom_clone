import 'package:colored_print/colored_print.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

class JitsimeetMethods {
  static Future<void> createNewMeeting() async {
    try {
      await JitsiMeetWrapper.joinMeeting(
        options: JitsiMeetingOptions(
          roomNameOrUrl: "roomText.text",
          subject: "About Zoom Clone",
          isAudioMuted: false,
          isAudioOnly: false,
          isVideoMuted: false,
          userDisplayName: "Kamesh Singh",
          userEmail: "kameshsinghaaa64@gmail.com",
        ),
        listener: JitsiMeetingListener(
          onOpened: () => ColoredPrint.warning("onOpened"),
          onConferenceWillJoin: (url) {
            ColoredPrint.warning("onConferenceWillJoin: url: $url");
          },
          onConferenceJoined: (url) {
            ColoredPrint.warning("onConferenceJoined: url: $url");
          },
          onConferenceTerminated: (url, error) {
            ColoredPrint.warning("onConferenceTerminated: url: $url, error: $error");
          },
          onAudioMutedChanged: (isMuted) {
            ColoredPrint.warning("onAudioMutedChanged: isMuted: $isMuted");
          },
          onVideoMutedChanged: (isMuted) {
            ColoredPrint.warning("onVideoMutedChanged: isMuted: $isMuted");
          },
          onScreenShareToggled: (participantId, isSharing) {
            ColoredPrint.warning(
              "onScreenShareToggled: participantId: $participantId, "
              "isSharing: $isSharing",
            );
          },
          onParticipantJoined: (email, name, role, participantId) {
            ColoredPrint.warning(
              "onParticipantJoined: email: $email, name: $name, role: $role, "
              "participantId: $participantId",
            );
          },
          onParticipantLeft: (participantId) {
            ColoredPrint.warning("onParticipantLeft: participantId: $participantId");
          },
          onParticipantsInfoRetrieved: (participantsInfo, requestId) {
            ColoredPrint.warning(
              "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
              "requestId: $requestId",
            );
          },
          onChatMessageReceived: (senderId, message, isPrivate) {
            ColoredPrint.warning(
              "onChatMessageReceived: senderId: $senderId, message: $message, "
              "isPrivate: $isPrivate",
            );
          },
          onChatToggled: (isOpen) => ColoredPrint.warning("onChatToggled: isOpen: $isOpen"),
          onClosed: () => ColoredPrint.warning("onClosed"),
        ),
      );
    } catch (error) {
      ColoredPrint.warning(error);
    }
  }
}
