import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/route_names.dart';

class StartMeetingPage extends StatefulWidget {
  final String personalMeetingID;

  const StartMeetingPage({super.key, required this.personalMeetingID});

  @override
  State<StartMeetingPage> createState() => _StartMeetingPageState();
}

class _StartMeetingPageState extends State<StartMeetingPage> {
  // variable declaration
  late final String name;
  late final String userID;
  late final String imageUrl;
  late DateTime joinDateTime;

  bool isVideoOn = true;
  bool usePersonalID = false;

  // This method genrate random Meeting ID if user does not use there personal ID.
  static String generate12DigitNumber() {
    Random random = Random();
    String number = '';

    for (int i = 0; i < 12; i++) {
      number += random.nextInt(10).toString(); // Random digit from 0-9
    }

    return number;
  }

  // Method for fetching current Provider user Data
  Future<void> getUserData() async {
    // creating instace of Shared Preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    name = prefs.getString('name') ?? "";
    userID = prefs.getString('userID') ?? "";
    imageUrl = prefs.getString('imageUrl') ?? "";
  }

  // Method for formating the Personal Meeting ID.
  String formatString(String input) {
    return input.replaceAllMapped(RegExp(r'.{1,4}'), (match) => '${match.group(0)} ').trim();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      //! AppBar
      appBar: AppBar(
        title: const Text(
          "Start a meeting",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontFamily: "Lato",
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            top: 17.5,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Color.fromRGBO(46, 119, 255, 1),
                fontSize: 17,
              ),
            ),
          ),
        ),
        leadingWidth: 90,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),
            //! Audio & Video Button Option's.
            const SizedBox(height: 4),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 41, 41, 41),
                border: Border(
                  top: BorderSide(
                    width: 0.5,
                    color: Color.fromARGB(255, 85, 85, 85),
                  ),
                  bottom: BorderSide(
                    width: 0.5,
                    color: Color.fromARGB(255, 85, 85, 85),
                  ),
                ),
              ),
              padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Video on",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  CupertinoSwitch(
                    value: isVideoOn,
                    onChanged: (value) {
                      setState(() {
                        isVideoOn = !isVideoOn;
                      });
                    },
                    activeColor: const Color.fromARGB(255, 44, 255, 51),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 41, 41, 41),
                border: Border(
                  top: BorderSide(
                    width: 0.5,
                    color: Color.fromARGB(255, 85, 85, 85),
                  ),
                  bottom: BorderSide(
                    width: 0.5,
                    color: Color.fromARGB(255, 85, 85, 85),
                  ),
                ),
              ),
              padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Use personal meeting ID (PMI)",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        formatString(widget.personalMeetingID),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  CupertinoSwitch(
                    value: usePersonalID,
                    onChanged: (value) {
                      setState(() {
                        usePersonalID = !usePersonalID;
                      });
                    },
                    activeColor: const Color.fromARGB(255, 44, 255, 51),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            //! Start a meeting Button.
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  minimumSize: const Size(370, 46),
                  backgroundColor: const Color.fromARGB(255, 41, 116, 255),
                ),
                onPressed: () {
                  //! If user select the personal Meeting ID then we pass the FireStore DB Personol ID to Meeting.
                  if (usePersonalID) {
                    Navigator.of(context).pushNamed(
                      RoutesNames.videoConferencePage,
                      arguments: {
                        "name": name,
                        "userID": userID,
                        "imageUrl": imageUrl,
                        "conferenceID": widget.personalMeetingID,
                        "isVideoOn": isVideoOn,
                        "joinDateTime": DateTime.now(),
                        "isMeetingCreated": true,
                      },
                    );
                  }
                  //! Else we genrate Random Meeeting ID.
                  else {
                    Navigator.of(context).pushNamed(
                      RoutesNames.videoConferencePage,
                      arguments: {
                        "name": name,
                        "userID": userID,
                        "imageUrl": imageUrl,
                        "conferenceID": generate12DigitNumber(),
                        "isVideoOn": isVideoOn,
                        "joinDateTime": DateTime.now(),
                        "isMeetingCreated": true,
                      },
                    );
                  }
                },
                child: const Text(
                  "Start a meeting",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
