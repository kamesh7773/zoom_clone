import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import '../../services/firebase_firestore_methods.dart';

class VideoConferencePage extends StatefulWidget {
  final String name;
  final String userID;
  final String imageUrl;
  final String conferenceID;
  final bool isVideoOn;
  final bool? isAudioOn;
  final bool? isMeetingCreated;

  const VideoConferencePage({
    super.key,
    required this.name,
    required this.userID,
    required this.imageUrl,
    required this.conferenceID,
    required this.isVideoOn,
    this.isAudioOn,
    this.isMeetingCreated,
  });

  @override
  State<VideoConferencePage> createState() => _VideoConferencePageState();
}

class _VideoConferencePageState extends State<VideoConferencePage> {
  // varible declaration.
  DateTime? joinDateTime;
  DateTime? conferenceStartTime;
  Duration totalDuration = Duration.zero;

  // Method for formating the Personal Meeting ID.
  String formatString(String input) {
    return input.replaceAllMapped(RegExp(r'.{1,4}'), (match) => '${match.group(0)} ').trim();
  }

  @override
  void initState() {
    joinDateTime = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    // Calculate the total duration when the video confer
    if (conferenceStartTime != null) {
      final conferenceEndTime = DateTime.now();
      final actualDuration = conferenceEndTime.difference(conferenceStartTime!);

      if (widget.isMeetingCreated != null) {
        // Loging Meeting Join & Leave Details.
        FireStoreCurdMethods.logMeetingDetails(
          imageURL: widget.imageUrl,
          joinTime: conferenceStartTime,
          leaveTime: conferenceEndTime,
          totalMeetingDuration: actualDuration,
          isMeetingCreated: widget.isMeetingCreated,
        );
      }
    }
  }

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
          turnOnCameraWhenJoining: widget.isVideoOn,
          turnOnMicrophoneWhenJoining: widget.isAudioOn == null ? true : widget.isAudioOn!,
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
          onLeaveConfirmation: (context) async {
            return true;
          },
          duration: ZegoVideoConferenceDurationConfig(
            isVisible: true,
            canSync: true,
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
                    "Hi,\nI’ve scheduled a meeting and would love for you to join! Here are the details:\n\nMeeting ID: ${formatString(widget.conferenceID)}\nJoin Link: [Your Meeting URL, if available]\n\nSimply enter the Meeting ID in the app to join. Looking forward to seeing you there!",
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
          )),
        events: ZegoUIKitPrebuiltVideoConferenceEvents(
          //! here we are calulating the totel time of Video Confrence.
          duration: ZegoVideoConferenceDurationEvents(
            onUpdated: (Duration duration) {
              // Record start time when duration begins
              if (conferenceStartTime == null && duration.inSeconds > 0) {
                conferenceStartTime = DateTime.now();
              }

              // Continuously update total duration
              totalDuration = duration;
            },
          ),
        ),
      ),
    );
  }
}
