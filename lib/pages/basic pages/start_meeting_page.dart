import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_clone/routes/route_names.dart';

class StartMeetingPage extends StatefulWidget {
  const StartMeetingPage({super.key});

  @override
  State<StartMeetingPage> createState() => _StartMeetingPageState();
}

class _StartMeetingPageState extends State<StartMeetingPage> {
  // variable declaration
  late final String name;
  late final String userID;
  late final String imageUrl;

  bool isVideoOn = true;
  bool usePersonalID = false;

  // Method for fetching current Provider user Data
  Future<void> getUserData() async {
    // creating instace of Shared Preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    name = prefs.getString('name') ?? "";
    userID = prefs.getString('userID') ?? "";
    imageUrl = prefs.getString('imageUrl') ?? "";
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
              "Cencel",
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Use personal meeting ID (PMI)",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "254 648 2079",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
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
            //! Continue Button.
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  minimumSize: const Size(370, 46),
                  backgroundColor: const Color.fromARGB(255, 41, 116, 255),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    RoutesNames.videoConferencePage,
                    arguments: {
                      "name": name,
                      "userID": userID,
                      "imageUrl": imageUrl,
                      "conferenceID": "25802580",
                    },
                  );
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
