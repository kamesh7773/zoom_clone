import 'package:flutter/material.dart';

class MeetingHistroy extends StatelessWidget {
  const MeetingHistroy({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 36, 36, 36),
      body: Center(
        child: Text(
          "Meeting History",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}