import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../basic%20pages/meeting_histroy.dart';
import '../basic%20pages/contacts_page.dart';
import '../basic%20pages/meetings_screen.dart';
import '../basic%20pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // varible declaration.
  int _page = 0;

  // List of Page for bottom Navigator Bar
  List<Widget> pages = [
    const MeetingScreen(),
    const MeetingHistroy(),
    const ContactsPage(),
    const SettingsPage(),
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
