import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(8, 92, 253, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(8, 92, 253, 1),
        leading: const Icon(
          Icons.settings_outlined,
          color: Colors.white,
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
                    style: TextStyle(fontSize: 50, color: Colors.white),
                  ),
                  Text(
                    "Workplace",
                    style: TextStyle(fontSize: 50, color: Colors.white),
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
                    onPressed: () {},
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
                    onPressed: () {},
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
                    onPressed: () {},
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
