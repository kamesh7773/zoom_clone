import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class VideoConferencePage extends StatefulWidget {
  // final String conferenceID;

  const VideoConferencePage({super.key});

  @override
  State<VideoConferencePage> createState() => _VideoConferencePageState();
}

class _VideoConferencePageState extends State<VideoConferencePage> {
  late final String name;
  late final String email;
  late final String userID;
  late final String imageUrl;

  // Method for fetching current Provider user Data
  Future<void> getUserData() async {
    // creating instace of Shared Preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    name = prefs.getString('name') ?? "";
    email = prefs.getString('email') ?? "";
    imageUrl = prefs.getString('imageUrl') ?? "";
    userID = prefs.getString('userID') ?? "";
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: 1472862173,
        appSign: "c7ae8f533225bd27922a858b08014e0aa8868c569ed35433638f821d07c1c3db",
        userID: userID,
        userName: name,
        conferenceID: "25802580",
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
                        image: NetworkImage(imageUrl),
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
