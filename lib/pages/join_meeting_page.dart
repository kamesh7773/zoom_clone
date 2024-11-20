import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:universal_html/html.dart' as html;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class JoinMeetingPage extends StatefulWidget {
  const JoinMeetingPage({super.key});

  @override
  State<JoinMeetingPage> createState() => _JoinMeetingPageState();
}

class _JoinMeetingPageState extends State<JoinMeetingPage> {
  // variable declaration
  Color joinButtonColor = const Color.fromARGB(255, 53, 52, 52);
  Color joinButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
  String? modelName;
  String? deviceBrand;
  bool isAudioOn = false;
  bool isVideoOn = false;

  // key's declaration
  final GlobalKey _formKey = GlobalKey<FormState>();

  // textediting controllar's
  TextEditingController meetingIDControllar = TextEditingController();

  // called every time when textediting controllar begin used.
  // Here we also validate the birth year textediting controllar for accepting the right birty year.
  listenPasswordTextEditingControllar() {
    if (RegExp(r'^(19[0-9]{2}|20[0-9]{2}|21[0-9]{2})$').hasMatch(meetingIDControllar.value.text) && meetingIDControllar.value.text.isNotEmpty) {
      setState(() {
        joinButtonColor = const Color.fromARGB(255, 41, 116, 255);
        joinButtonTextColor = const Color.fromARGB(255, 255, 255, 255);
      });
    } else {
      setState(() {
        joinButtonColor = const Color.fromARGB(255, 53, 52, 52);
        joinButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }
  }

  // Method that retrive the current device model name.
  Future<void> deviceModelName() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final userAgent = html.window.navigator.userAgent;
    // Android model detection
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      modelName = androidInfo.model;
      deviceBrand = androidInfo.brand;
    }

    // Browser detection using user agent string
    if (userAgent.contains("Chrome") && !userAgent.contains("Edge") && !userAgent.contains("OPR")) {
      final version = userAgent.split("Chrome/")[1].split(" ")[0];
      modelName = "Google Chrome (Version: $version)";
    } else if (userAgent.contains("Firefox")) {
      final version = userAgent.split("Firefox/")[1];
      modelName = "Mozilla Firefox (Version: $version)";
    } else if (userAgent.contains("Safari") && !userAgent.contains("Chrome")) {
      final version = userAgent.split("Version/")[1].split(" ")[0];
      modelName = "Apple Safari (Version: $version)";
    } else if (userAgent.contains("Edge")) {
      final version = userAgent.split("Edg/")[1];
      modelName = "Microsoft Edge (Version: $version)";
    } else if (userAgent.contains("OPR")) {
      final version = userAgent.split("OPR/")[1];
      modelName = "Opera (Version: $version)";
    }
  }

  @override
  void initState() {
    super.initState();
    // method that listen the Textediting Controllar.
    meetingIDControllar.addListener(listenPasswordTextEditingControllar);
    deviceModelName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      //! AppBar
      appBar: AppBar(
        title: const Text(
          "Join",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(46, 119, 255, 1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  "Verify your age",
                  style: TextStyle(
                    color: Color.fromARGB(255, 168, 168, 168),
                    fontSize: 14,
                    fontFamily: "Lato",
                  ),
                ),
              ),
              const SizedBox(height: 8),
              //! Meeting ID Textediting Controller
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
                child: TextFormField(
                  autofocus: true,
                  controller: meetingIDControllar,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.lightBlue,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: "Meeting ID",
                    hintStyle: TextStyle(color: Color.fromARGB(255, 102, 102, 102)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Center(
                child: Text(
                  "Current device name",
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Color.fromRGBO(46, 119, 255, 1),
                  ),
                ),
              ),
              //! Current Device Model & Brand Name.
              const SizedBox(height: 18),
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
                padding: const EdgeInsets.all(13),
                alignment: Alignment.center,
                child: Text(
                  "$deviceBrand $modelName",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              //! Privacy Policy & Term of Services Section.
              const Padding(
                padding: EdgeInsets.only(left: 14.0, top: 6.0),
                child: Wrap(
                  children: [
                    Text(
                      "By clicking 'Join',you agree to our",
                      style: TextStyle(
                        color: Color.fromARGB(255, 136, 135, 135),
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      " Terms of Service",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      " and",
                      style: TextStyle(
                        color: Color.fromARGB(255, 136, 135, 135),
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      " Privacy",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "Statement",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              //! Continue Button.
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    minimumSize: const Size(370, 46),
                    backgroundColor: joinButtonColor,
                  ),
                  onPressed: () {
                    if (meetingIDControllar.value.text.isEmpty) {
                    } else {}
                  },
                  child: Text(
                    "Join",
                    style: TextStyle(
                      fontSize: 16,
                      color: joinButtonTextColor,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 18.0, top: 10.0, right: 8.0),
                child: Text(
                  "Please enter your Meeting ID and join the meeting",
                  style: TextStyle(
                    color: Color.fromARGB(255, 136, 135, 135),
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              //! Audio & Video Button Option's.
              const Padding(
                padding: EdgeInsets.only(left: 18.0),
                child: Text(
                  "Join options",
                  style: TextStyle(
                    color: Color.fromARGB(255, 136, 135, 135),
                    fontSize: 14,
                  ),
                ),
              ),
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
                      "Don't connect to audio",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    CupertinoSwitch(
                      value: isAudioOn,
                      onChanged: (value) {
                        setState(() {
                          isAudioOn = !isAudioOn;
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
                    const Text(
                      "Turn off my video",
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
            ],
          ),
        ),
      ),
    );
  }
}
