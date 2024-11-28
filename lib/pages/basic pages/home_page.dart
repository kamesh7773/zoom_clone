import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoom_clone/services/firebase_auth_methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // varible declaration.
  int _page = 0;

  // Method for changing screen when user taps on BottomNavigation Icon.
  void onPagedChanged(int page) {
    setState(() {
      _page = page;
    });
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
                  Container(
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
                  Container(
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
                  Container(
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
              label: "Chat",
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
