import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zoom_clone/routes/route_names.dart';
import 'package:zoom_clone/services/firebase_firestore_methods.dart';

class MeetingHistroy extends StatefulWidget {
  const MeetingHistroy({super.key});

  @override
  State<MeetingHistroy> createState() => _MeetingHistroyState();
}

class _MeetingHistroyState extends State<MeetingHistroy> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (value, result) {
        if (!value) {
          //! On press redirect user to homePage.
          Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesNames.homePage,
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        //! AppBar
        appBar: AppBar(
          title: const Text(
            "Meeting history",
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
              //! On press redirect user to Welcome Page.
              //! On press redirect user to homePage.
              Navigator.of(context).pushNamedAndRemoveUntil(
                RoutesNames.homePage,
                (Route<dynamic> route) => false,
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color.fromRGBO(46, 119, 255, 1),
            ),
          ),
        ),
        body: StreamBuilder(
          stream: FireStoreCurdMethods.readMeetingDetails(),
          builder: (context, snapshot) {

            // While snapshot is fetching data, show loading indicator
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey), // Change the color here
                backgroundColor: Colors.white, // Optional: Change the background color
              );
            }

            //
          },
        ),
      ),
    );
  }
}
