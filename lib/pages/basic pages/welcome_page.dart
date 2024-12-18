import 'dart:async';
import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import '../../routes/route_names.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Declaring StreamSubscription for listening to deep links (when the user enters the app via deep links)
  StreamSubscription? _sub;
  // Creating AppLink class Object.
  final AppLinks appLinks = AppLinks();

  // This method generates a random Meeting ID if the user does not use their personal ID
  static String generate12DigitNumber() {
    Random random = Random();
    String number = '';

    for (int i = 0; i < 12; i++) {
      number += random.nextInt(10).toString(); // Random digit from 0-9
    }

    return number;
  }

  // Method to listen for deep links
  void _initDeepLinkListener() {
    _sub = appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        // Retrieve the conference ID
        String? conferenceID = uri.queryParameters['code'];
        // If conferenceID is not null, redirect the user to the video conference page
        if (conferenceID != null && mounted) {
          Navigator.of(context).pushNamed(
            RoutesNames.videoConferencePage,
            arguments: {
              "name": "Anonymous",
              "userID": generate12DigitNumber(),
              "imageUrl": "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=",
              "conferenceID": conferenceID,
              "isVideoOn": true,
              "isAudioOn": true,
              "joinDateTime": DateTime.now(),
            },
          );
        }
      }
    }, onError: (err) {
      throw err.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(8, 92, 253, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(8, 92, 253, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.settings_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(RoutesNames.welcomeSettingsPage);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Container(
              color: const Color.fromRGBO(8, 92, 253, 1),
              child: const Column(
                children: [
                  Text(
                    "Zoom",
                    style: TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                      fontFamily: "Kaleko",
                      fontWeight: FontWeight.normal,
                      height: 0.5,
                    ),
                  ),
                  Text(
                    "Workplace",
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: "Lato",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 1),
            Container(
              width: double.infinity,
              height: 330,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 36, 36, 36),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 45),
                  const Text(
                    "Welcome",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const Text(
                    "Get started with your account",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      minimumSize: const Size(370, 48),
                      backgroundColor: const Color.fromRGBO(26, 129, 255, 1),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        RoutesNames.joinMeetingPage,
                      );
                    },
                    child: const Text(
                      "Join a meeting",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      minimumSize: const Size(370, 48),
                      backgroundColor: const Color.fromARGB(255, 68, 68, 68),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        RoutesNames.signUpPage_1,
                        arguments: {
                          "title": "C O N T A C T S   P A G E",
                        },
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      minimumSize: const Size(370, 48),
                      backgroundColor: const Color.fromARGB(255, 68, 68, 68),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        RoutesNames.signInPage,
                        arguments: {
                          "title": "C O N T A C T S   P A G E",
                        },
                      );
                    },
                    child: const Text(
                      "Sign in",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
