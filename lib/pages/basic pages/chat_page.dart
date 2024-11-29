import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 36, 36, 36),
      body: Center(
        child: Text(
          "Chat Page",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
