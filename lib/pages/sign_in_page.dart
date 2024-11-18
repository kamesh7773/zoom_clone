import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      appBar: AppBar(
        title: const Text(
          "Sing in",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Lato",
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(46, 119, 255, 1),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Text(
              "Enter your email address",
              style: TextStyle(
                color: Color.fromARGB(255, 168, 168, 168),
                fontSize: 14,
                fontFamily: "Lato",
              ),
            ),
          ),
          //! Email Textediting Controller
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 43, 42, 42),
              border: Border(
                top: BorderSide(
                  width: 0.5,
                  color: Color.fromARGB(255, 85, 85, 85),
                ),
                bottom: BorderSide(
                  width: 0.25,
                  color: Color.fromARGB(255, 85, 85, 85),
                ),
              ),
            ),
            child: const TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: TextStyle(color: Color.fromARGB(255, 124, 123, 123)),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          //! Password Textediting Controller
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 43, 42, 42),
              border: Border(
                top: BorderSide(
                  width: 0.5,
                  color: Color.fromARGB(255, 85, 85, 85),
                ),
                bottom: BorderSide(
                  width: 0.25,
                  color: Color.fromARGB(255, 109, 109, 109),
                ),
              ),
            ),
            child: const TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 124, 123, 123),
                ),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(height: 18),
          //! Sing In Button.
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                minimumSize: const Size(370, 46),
                backgroundColor: const Color.fromARGB(255, 53, 52, 52),
                foregroundColor: Colors.white,
              ),
              onPressed: () {},
              child: const Text(
                "Sing in",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 124, 123, 123),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
