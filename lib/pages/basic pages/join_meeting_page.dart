import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/firebase_auth_methods.dart';
import '../../routes/route_names.dart';

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

  // varible for user details
  late final String name;
  late final String userID;
  late final String imageUrl;

  // Checking if the user is already logged in
  bool isUserAuthenticated = false;

  // key's declaration
  final GlobalKey _formKey = GlobalKey<FormState>();

  // textediting controllar's
  TextEditingController conferenceIDControllar = TextEditingController();

  // called every time when textediting controllar begin used.
  // Here we also validate the birth year textediting controllar for accepting the right birty year.
  listenPasswordTextEditingControllar() {
    if (conferenceIDControllar.value.text.length == 14) {
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

  // This method checkes weather user is authenticated of not.
  Future<void> isUserAuthenticate() async {
    isUserAuthenticated = await FirebaseAuthMethods.isUserLogin();
  }

  // This method genrate random Meeting ID if user does not use there personal ID.
  static String generate12DigitNumber() {
    Random random = Random();
    String number = '';

    for (int i = 0; i < 12; i++) {
      number += random.nextInt(10).toString(); // Random digit from 0-9
    }

    return number;
  }

  // -----------------------------------
  // Method for formatting conference ID
  // -----------------------------------
  void _formatText() {
    String text = conferenceIDControllar.text.replaceAll(' ', ''); // Remove existing spaces
    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      formatted += text[i];
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        formatted += ' '; // Add a space after every 3 characters
      }
    }

    // Update the controller text and move cursor to the correct position
    if (formatted != conferenceIDControllar.text) {
      conferenceIDControllar.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  // -------------------------------------------------
  // Method that retrive the current device model name
  // -------------------------------------------------
  Future<void> deviceModelName() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    // Android model detection
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      modelName = androidInfo.model;
      deviceBrand = androidInfo.brand;
    }
  }

  // ----------------------------------------------
  // Method for fetching current Provider user Data
  // ----------------------------------------------
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
    // method that listen the Textediting Controllar.
    conferenceIDControllar.addListener(listenPasswordTextEditingControllar);
    conferenceIDControllar.addListener(_formatText);
    deviceModelName();
    getUserData();
    isUserAuthenticate();
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
            fontSize: 18,
            color: Colors.white,
            fontFamily: "Lato",
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
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
              const SizedBox(height: 14),
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
                  controller: conferenceIDControllar,
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
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Allow only numbers
                    LengthLimitingTextInputFormatter(12),
                  ],
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
              //! Join Button.
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    minimumSize: const Size(370, 46),
                    backgroundColor: joinButtonColor,
                  ),
                  onPressed: () {
                    if (conferenceIDControllar.value.text.length == 14) {
                      //! If user is authenticated then we start video confresce via User Details
                      if (isUserAuthenticated) {
                        Navigator.of(context).pushNamed(
                          RoutesNames.videoConferencePage,
                          arguments: {
                            "name": name,
                            "userID": userID,
                            "imageUrl": imageUrl,
                            "conferenceID": conferenceIDControllar.value.text.replaceAll(' ', ''),
                            "isVideoOn": !isVideoOn,
                            "isAudioOn": !isAudioOn,
                            "isMeetingCreated": false,
                          },
                        );
                        //! If user is not authenticated then we provide the random UserID and Anonymous Name.
                      } else {
                        Navigator.of(context).pushNamed(
                          RoutesNames.videoConferencePage,
                          arguments: {
                            "name": "Anonymous",
                            "userID": generate12DigitNumber(),
                            "imageUrl": "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=",
                            "conferenceID": conferenceIDControllar.value.text.replaceAll(' ', ''),
                            "isVideoOn": !isVideoOn,
                            "isAudioOn": !isAudioOn,
                          },
                        );
                      }
                    }
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
