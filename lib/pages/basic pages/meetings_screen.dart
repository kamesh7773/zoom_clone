import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/route_names.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  // Variable declaration
  late final String personalMeetingID;

  // Method for fetching the current user's data from SharedPreferences
  Future<void> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    personalMeetingID = prefs.getString('personalMeetingID') ?? "";
  }

  // Method for formatting the Personal Meeting ID
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
              // Bottom Sheet Widget
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                enableDrag: true,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 270,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 46, 46, 46),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            16,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "Personal meeting ID",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatString(personalMeetingID),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Start Meeting Section
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            margin: const EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 58, 57, 57),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Start meeting",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Divider(
                              height: 0.0,
                              thickness: 0.3,
                            ),
                          ),
                          // Send Invitation Section
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            margin: const EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 58, 57, 57),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Send Invitation",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.screen_share_outlined,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Divider(
                              height: 0.0,
                              thickness: 0.3,
                            ),
                          ),
                          // Edit Meeting Section
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            margin: const EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 58, 57, 57),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Edit meeting",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
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
              // New Meeting Button
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (context.mounted) {
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
              // Join Button
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
              // Schedule Button
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
              // Share Screen Button
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
