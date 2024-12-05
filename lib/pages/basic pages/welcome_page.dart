import 'package:flutter/material.dart';
import '../../routes/route_names.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(8, 92, 253, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(8, 92, 253, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.settings_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(RoutesNames.welcomeSettingsPage);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Container(
              color: const Color.fromRGBO(8, 92, 253, 1),
              child: const Column(
                children: [
                  Text(
                    "Zoom",
                    style: TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                      fontFamily: "Kaleko",
                      fontWeight: FontWeight.normal,
                      height: 0.5,
                    ),
                  ),
                  Text(
                    "Workplace",
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: "Lato",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 1),
            Container(
              width: double.infinity,
              height: 330,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 36, 36, 36),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 45),
                  const Text(
                    "Welcome",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const Text(
                    "Get started with your account",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      minimumSize: const Size(370, 48),
                      backgroundColor: const Color.fromRGBO(26, 129, 255, 1),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        RoutesNames.joinMeetingPage,
                      );
                    },
                    child: const Text(
                      "Join a meeting",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      minimumSize: const Size(370, 48),
                      backgroundColor: const Color.fromARGB(255, 68, 68, 68),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        RoutesNames.signUpPage_1,
                        arguments: {
                          "title": "C O N T A C T S   P A G E",
                        },
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      minimumSize: const Size(370, 48),
                      backgroundColor: const Color.fromARGB(255, 68, 68, 68),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        RoutesNames.signInPage,
                        arguments: {
                          "title": "C O N T A C T S   P A G E",
                        },
                      );
                    },
                    child: const Text(
                      "Sign in",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
