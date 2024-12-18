import 'package:flutter/material.dart';

import '../../services/firebase_auth_methods.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Variable declaration
  final GlobalKey _formKey = GlobalKey<FormState>();
  Color sendButtonColor = const Color.fromARGB(255, 53, 52, 52);
  Color sendButtonTextColor = const Color.fromARGB(255, 124, 123, 123);

  // TextEditingController for email input
  late TextEditingController emailController;

  //? --------------------------
  //? Method for forgot Password
  //? --------------------------
  // Method for sending the reset password link to user's when they forgot there password.
  void forgotPassword() {
    FirebaseAuthMethods.forgotEmailPassword(
      email: emailController.value.text.trim(),
      context: context,
    );
  }

  // Method to listen to changes in the email input field
  // Updates the button color based on email validity
  void listenEmailTextEditingController() {
    if (RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(emailController.value.text) && emailController.value.text.isNotEmpty) {
      setState(() {
        sendButtonColor = const Color.fromARGB(255, 41, 116, 255);
        sendButtonTextColor = const Color.fromARGB(255, 255, 255, 255);
      });
    } else {
      setState(() {
        sendButtonColor = const Color.fromARGB(255, 53, 52, 52);
        sendButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    // Add a listener to the email input field
    emailController.addListener(listenEmailTextEditingController);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      // AppBar
      appBar: AppBar(
        title: const Text(
          "Forgot password",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Lato",
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(46, 119, 255, 1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 26),
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
              const SizedBox(height: 8),
              //! Birth year Textediting Controller
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 43, 42, 42),
                  border: Border(
                    top: BorderSide(
                      width: 0.5,
                      color: Color.fromARGB(255, 85, 85, 85),
                    ),
                    bottom: BorderSide(
                      width: 0.5,
                      color: Color.fromARGB(255, 85, 85, 85),
                    ),
                  ),
                ),
                child: TextFormField(
                  controller: emailController,
                  cursorColor: Colors.lightBlue,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Color.fromARGB(255, 124, 123, 123)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
              //! Forgot Password Button
              const Padding(
                padding: EdgeInsets.only(left: 6, top: 10),
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Text(
                    "To reset your password, please enter your email address.\nYou may need to check your spam folder or unblock no-reply@zoom.us.",
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Color.fromARGB(255, 141, 141, 141),
                    ),
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
                    backgroundColor: sendButtonColor,
                  ),
                  onPressed: () {
                    if (RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(emailController.value.text)) {
                      forgotPassword();
                    }
                  },
                  child: Text(
                    "Send",
                    style: TextStyle(
                      fontSize: 16,
                      color: sendButtonTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
