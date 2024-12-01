import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class VideoConferencePage extends StatefulWidget {
  final String name;
  final String userID;
  final String imageUrl;
  final String conferenceID;
  const VideoConferencePage({
    super.key,
    required this.name,
    required this.userID,
    required this.imageUrl,
    required this.conferenceID,
  });

  @override
  State<VideoConferencePage> createState() => _VideoConferencePageState();
}

class _VideoConferencePageState extends State<VideoConferencePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: 1472862173,
        appSign: "c7ae8f533225bd27922a858b08014e0aa8868c569ed35433638f821d07c1c3db",
        userID: widget.userID,
        userName: widget.name,
        conferenceID: widget.conferenceID,
        config: (ZegoUIKitPrebuiltVideoConferenceConfig(
          turnOnCameraWhenJoining: true,
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
          //! Top Appbar UI custmization.
          topMenuBarConfig: ZegoTopMenuBarConfig(
            extendButtons: [
              IconButton(
                onPressed: () async {
                  await Share.share(
                    "Share conference ID",
                    subject: "Hi i want to share this link",
                  );
                },
                color: Colors.white,
                icon: const Icon(Icons.share),
              ),
            ],
            title: "Host by : ",
            isVisible: true,
            hideAutomatically: false,
            hideByClick: false,
            buttons: [
              ZegoMenuBarButtonName.showMemberListButton,
              ZegoMenuBarButtonName.toggleScreenSharingButton,
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
                hideAutomatically: false,
                hideByClick: false,
                buttons: [
                  ZegoMenuBarButtonName.chatButton,
                  ZegoMenuBarButtonName.switchCameraButton,
                  ZegoMenuBarButtonName.toggleMicrophoneButton,
                  ZegoMenuBarButtonName.leaveButton,
                ],
              ) // Add a screen sharing toggle button.
            ),
      ),
    );
  }
}
