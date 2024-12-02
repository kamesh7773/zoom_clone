import 'package:colored_print/colored_print.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class VideoConferencePage extends StatefulWidget {
  final String name;
  final String userID;
  final String imageUrl;
  final String conferenceID;
  final bool isVideoOn;
  const VideoConferencePage({
    super.key,
    required this.name,
    required this.userID,
    required this.imageUrl,
    required this.conferenceID,
    required this.isVideoOn,
  });

  @override
  State<VideoConferencePage> createState() => _VideoConferencePageState();
}

class _VideoConferencePageState extends State<VideoConferencePage> {
  // Method for formating the Personal Meeting ID.
  String formatString(String input) {
    return input.replaceAllMapped(RegExp(r'.{1,4}'), (match) => '${match.group(0)} ').trim();
  }

  @override
  Widget build(BuildContext context) {
    ColoredPrint.warning(widget.conferenceID);
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: 1472862173,
        appSign: "c7ae8f533225bd27922a858b08014e0aa8868c569ed35433638f821d07c1c3db",
        userID: widget.userID,
        userName: widget.name,
        conferenceID: widget.conferenceID,
        config: (ZegoUIKitPrebuiltVideoConferenceConfig(
          turnOnCameraWhenJoining: widget.isVideoOn,
          turnOnMicrophoneWhenJoining: true,
          useFrontFacingCamera: true,
          //! This is Avatar image of User Profile.
          avatarBuilder: (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
            return user != null
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(widget.imageUrl),
                      ),
                    ),
                  )
                : const SizedBox();
          },
          notificationViewConfig: ZegoInRoomNotificationViewConfig(
            notifyUserLeave: true,
          ),
          //! Modify your custom configurations here.
          leaveConfirmDialogInfo: ZegoLeaveConfirmDialogInfo(
            title: "Leave the conference",
            message: "Are you sure to leave the conference?",
            cancelButtonName: "Cancel",
            confirmButtonName: "Confirm",
          ),
          //! Top Appbar UI custmization.
          topMenuBarConfig: ZegoTopMenuBarConfig(
            title: "Meeting",
            hideByClick: true,
            hideAutomatically: false,
            isVisible: true,
            buttons: [
              ZegoMenuBarButtonName.showMemberListButton,
              ZegoMenuBarButtonName.toggleScreenSharingButton,
              ZegoMenuBarButtonName.switchCameraButton,
            ],
          ),
        )
              //! Zego UI Custmization Options for Bottom Navigation Button.
              ..layout = ZegoLayout.gallery(
                addBorderRadiusAndSpacingBetweenView: true,
                showScreenSharingFullscreenModeToggleButtonRules: ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
                showNewScreenSharingViewInFullscreenMode: true,
              ) // Set the layout to gallery mode. and configure the [showNewScreenSharingViewInFullscreenMode] and [showScreenSharingFullscreenModeToggleButtonRules].
              ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
                hideByClick: true,
                hideAutomatically: false,
                maxCount: 5,
                extendButtons: [
                  IconButton(
                    onPressed: () async {
                      await Share.share(
                        formatString(widget.conferenceID),
                        subject: "Hi i want to share this link",
                      );
                    },
                    color: Colors.white,
                    icon: const Icon(Icons.share),
                  ),
                ],
                buttons: [
                  ZegoMenuBarButtonName.toggleMicrophoneButton,
                  ZegoMenuBarButtonName.toggleCameraButton,
                  ZegoMenuBarButtonName.leaveButton,
                  ZegoMenuBarButtonName.chatButton,
                  ZegoMenuBarButtonName.switchAudioOutputButton,
                ],
              ) // Add a screen sharing toggle button.
            ),
      ),
    );
  }
}
