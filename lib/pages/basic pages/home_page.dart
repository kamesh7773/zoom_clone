import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links2/uni_links.dart';
import '../../routes/route_names.dart';
import '../basic%20pages/main_settings.dart';
import '../basic%20pages/meeting_histroy.dart';
import '../basic%20pages/contacts_page.dart';
import '../basic%20pages/meetings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // Variable declarations
  int _page = 0;

  late final String name;
  late final String userID;
  late final String imageUrl;

  // StreamSubscription for listening to deep links (when the user enters the app via deep links)
  StreamSubscription? _sub;

  // Method for fetching the current user's data from SharedPreferences
  Future<void> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    name = prefs.getString('name') ?? "";
    userID = prefs.getString('userID') ?? "";
    imageUrl = prefs.getString('imageUrl') ?? "";
  }

  // Method to listen for deep links
  void _initDeepLinkListener() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        // Retrieve the conference ID
        String? conferenceID = uri.queryParameters['code'];
        // If conferenceID is not null, redirect the user to the video conference page
        if (conferenceID != null && mounted) {
          Navigator.of(context).pushNamed(
            RoutesNames.videoConferencePage,
            arguments: {
              "name": name,
              "userID": userID,
              "imageUrl": imageUrl,
              "conferenceID": conferenceID,
              "isVideoOn": true,
              "joinDateTime": DateTime.now(),
              "isMeetingCreated": false,
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
    getUserData();
    _initDeepLinkListener();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  // List of pages for the bottom navigation bar
  List<Widget> pages = [
    const MeetingScreen(),
    const MeetingHistroy(),
    const ContactsPage(),
    const MainSettings(),
  ];

  // Method for changing the screen when the user taps on a bottom navigation icon
  void onPagedChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pages[_page],
      // Bottom Navigation Bar
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: const Color.fromARGB(255, 32, 32, 32),
          highlightColor: const Color.fromARGB(255, 32, 32, 32),
          applyElevationOverlayColor: false,
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 32, 32, 32),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          unselectedFontSize: 14.0,
          selectedFontSize: 14.0,
          type: BottomNavigationBarType.fixed,
          onTap: onPagedChanged,
          currentIndex: _page,
          items: const [
            // Meetings
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.video,
                size: 21,
              ),
              label: "Meetings",
            ),
            // Meeting History
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
                size: 24,
              ),
              label: "Meeting History",
            ),
            // Contacts
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 29,
              ),
              label: "Contact",
            ),
            // Settings
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: 29,
              ),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
