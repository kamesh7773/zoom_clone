import 'package:flutter/material.dart';
import 'package:zoom_clone/routes/route_names.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (value, result) {
        if (!value) {
          // On press, redirect the user to the home page
          Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesNames.homePage,
            (Route<dynamic> route) => false,
          );
        }
      },
      child: const Scaffold(
        backgroundColor: Color.fromARGB(255, 36, 36, 36),
        body: Center(
          child: Text(
            "Contacts Page",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
