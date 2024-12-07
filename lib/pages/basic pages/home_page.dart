import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links2/uni_links.dart';
import 'package:zoom_clone/routes/route_names.dart';
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
  // varible declaration.
  int _page = 0;

  late final String name;
  late final String userID;
  late final String imageUrl;

  // declaring StreamSubscription for listening the deeplinks (When user enter the app via deeplinks)
  StreamSubscription? _sub;

  // Method for fetching current Provider user Data
  Future<void> getUserData() async {
    // creating instace of Shared Preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    name = prefs.getString('name') ?? "";
    userID = prefs.getString('userID') ?? "";
    imageUrl = prefs.getString('imageUrl') ?? "";
  }

  // Method that listen for deeplinks.
  void _initDeepLinkListener() {
    // listening the deeplink URI.
    _sub = uriLinkStream.listen((Uri? uri) {
      // if URI is not null then..
      if (uri != null) {
        // retriving the conferenceID
        String? conferenceID = uri.queryParameters['code'];
        // if conferenceID is not null then we redirect the "User" to "videoConferencePage".
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

  // List of Page for bottom Navigator Bar
  List<Widget> pages = [
    const MeetingScreen(),
    const MeetingHistroy(),
    const ContactsPage(),
    const MainSettings(),
  ];

  // Method for changing screen when user taps on BottomNavigation Icon.
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
      //! Bottem Navigation Bar.
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
            //! Meetings.
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.video,
                size: 21,
              ),
              label: "Meetings",
            ),

            //! Chat.
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
                size: 24,
              ),
              label: "Meeting History",
            ),

            //! Contancts
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 29,
              ),
              label: "Contact",
            ),

            //! Settings.
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
