import 'package:flutter/material.dart';
import 'package:zoom_clone/routes/route_names.dart';

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
        // body: StreamBuilder(
        //   stream: stream,
        //   builder: (context, snapshot) {},
        // ),
      ),
    );
  }
}
