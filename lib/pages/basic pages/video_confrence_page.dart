import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class VideoConferencePage extends StatelessWidget {
  // final String conferenceID;

  const VideoConferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: 1472862173,
        appSign: "c7ae8f533225bd27922a858b08014e0aa8868c569ed35433638f821d07c1c3db",
        userID: "kamesh7773",
        userName: "montu",
        conferenceID: "25802580",
        config: (ZegoUIKitPrebuiltVideoConferenceConfig(
          turnOnCameraWhenJoining: true,
          useFrontFacingCamera: true,
          turnOnMicrophoneWhenJoining: true,
        )
              ..layout = ZegoLayout.gallery(
                addBorderRadiusAndSpacingBetweenView: true,
                showScreenSharingFullscreenModeToggleButtonRules: ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
                showNewScreenSharingViewInFullscreenMode: false,
              ) // Set the layout to gallery mode. and configure the [showNewScreenSharingViewInFullscreenMode] and [showScreenSharingFullscreenModeToggleButtonRules].
              ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
                buttons: [
                  ZegoMenuBarButtonName.chatButton,
                  ZegoMenuBarButtonName.switchCameraButton,
                  ZegoMenuBarButtonName.toggleMicrophoneButton,
                  ZegoMenuBarButtonName.toggleScreenSharingButton,
                  ZegoMenuBarButtonName.leaveButton,
                ],
              ) // Add a screen sharing toggle button.
            ),
      ),
    );
  }
}
