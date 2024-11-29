import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 36, 36, 36),
      body: Center(
        child: Text(
          "Contacts Page",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
