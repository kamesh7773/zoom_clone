import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'package:zoom_clone/routes/route_names.dart';
import 'package:zoom_clone/services/firebase_auth_methods.dart';
import 'package:zoom_clone/widgets/diolog_box.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  // Variables related to Firebase instances
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // variable declaration
  String? personalMeetingID;

  // Method for fetching personal Meeting ID from FireStore.
  Future<void> getUserPersonalMeetingID() async {
    try {
      // fetching current userId info from "users" collection.
      final currentUserInfo = await _db.collection("users").doc(_auth.currentUser!.uid).get();
      final userData = currentUserInfo.data();

      personalMeetingID = userData?["personalMeetingID"];
    } on FirebaseException catch (error) {
      if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && mounted) {
        Navigator.pop(context);
        PopUpWidgets.diologbox(
          context: context,
          title: "Network failure",
          content: "Connection failed. Please check your network connection and try again.",
        );
      } else {
        if (mounted) {
          Navigator.pop(context);
          PopUpWidgets.diologbox(
            context: context,
            title: "Network Error",
            content: error.toString(),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // getUserPersonalMeetingID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      appBar: AppBar(
        title: const Text(
          "Meetings",
          style: TextStyle(
            fontSize: 19,
            color: Colors.white,
            fontFamily: "Lato",
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuthMethods.singOut(context: context);
            },
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //! New Meeting Button.
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await getUserPersonalMeetingID();
                      if (context.mounted && personalMeetingID != null) {
                        Navigator.of(context).pushNamed(
                          RoutesNames.startMeetingPage,
                          arguments: {
                            "personalMeetingID": personalMeetingID,
                          },
                        );
                      }
                    },
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 134, 35),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.video,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "New meeting",
                    style: TextStyle(
                      color: Color.fromARGB(255, 142, 142, 142),
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              //! Join Button.
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RoutesNames.joinMeetingPage,
                      );
                    },
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(61, 132, 255, 1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add_box_rounded,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Join",
                    style: TextStyle(
                      color: Color.fromARGB(255, 142, 142, 142),
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              //! Schedule Button.
              Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(61, 132, 255, 1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.calendarCheck,
                          size: 26,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Schedule",
                    style: TextStyle(
                      color: Color.fromARGB(255, 142, 142, 142),
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              //! Share screen Button.
              Column(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(61, 132, 255, 1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.upload,
                        size: 26,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Share screen",
                    style: TextStyle(
                      color: Color.fromARGB(255, 142, 142, 142),
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.2,
          )
        ],
      ),
    );
  }
}
