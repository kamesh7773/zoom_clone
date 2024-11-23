import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 32, 32, 32),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Zoom",
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontFamily: "Lato",
                fontWeight: FontWeight.normal,
                height: 0.8,
              ),
            ),
            Text(
              "Workplace",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontFamily: "Lato",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
