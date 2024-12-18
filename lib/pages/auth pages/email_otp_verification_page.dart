import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../../services/firebase_auth_methods.dart';

class OtpVerificationPage extends StatefulWidget {
  final String birthYear;
  final String email;
  final String fname;
  final String lname;
  final String password;
  const OtpVerificationPage({
    super.key,
    required this.birthYear,
    required this.email,
    required this.fname,
    required this.lname,
    required this.password,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  // Variable declaration.
  Color resentButtonColor = const Color.fromRGBO(46, 119, 255, 1);
  late TextEditingController pinputController;

  // Variables for OTP Timer.
  bool resentButton = true;
  int minutes = 0;
  int seconds = 0;
  Duration duration = const Duration(seconds: 5);
  Timer? timer;
  int incrementSecond = 0;

  void startTimer() {
    duration = Duration(seconds: 120 + incrementSecond);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (duration.inSeconds > 0) {
        duration -= const Duration(seconds: 1);
        minutes = duration.inMinutes;
        seconds = duration.inSeconds % 60;
        setState(() {});
      } else {
        timer.cancel();
        resentButton = true;
        incrementSecond += 240;
        duration = Duration(seconds: 120 + incrementSecond);
        setState(() {});
      }
    });
  }

  // Method to reset the timer and buttons to default when the user clicks the back button.
  // This handles cases where the user accidentally presses the back button.
  void resetTimerAndBtn() {
    timer!.cancel();
    resentButton = false;
    duration = Duration(seconds: 120 + incrementSecond);
  }

  // Method to verify the OTP.
  void verifyOTP() {
    FirebaseAuthMethods.verifyEmailOTP(
      birthYear: widget.birthYear,
      email: widget.email,
      fname: widget.fname,
      lname: widget.lname,
      password: widget.password,
      emailOTP: pinputController.value.text,
      context: context,
    );
  }

  // Method to resend the OTP.
  void resentOTP() {
    // Restart the timer and disable the OTP resend button.
    startTimer();
    resentButton = false;

    // Uncomment the following lines to enable OTP resend functionality.
    // FirebaseAuthMethods.resentEmailOTP(
    //   email: widget.email,
    //   context: context,
    // );
  }

  @override
  void initState() {
    super.initState();
    pinputController = TextEditingController();
  }

  @override
  void dispose() {
    pinputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int initialMinutes = incrementSecond ~/ 60;
    int initialSeconds = incrementSecond % 60;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      // AppBar
      appBar: AppBar(
        title: const Text(
          "Verification",
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
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(46, 119, 255, 1),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 52),
            const Text(
              "Check your email for a code",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Please enter the verification code sent to your email address.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 26),
            // Pinput Widget.
            Pinput(
              autofocus: true,
              controller: pinputController,
              length: 6,
              keyboardType: TextInputType.number,
              onCompleted: (value) {
                verifyOTP();
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              defaultPinTheme: const PinTheme(
                width: 30,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 36, 36, 36),
                  backgroundBlendMode: BlendMode.color,
                  border: Border(
                    bottom: BorderSide(color: Colors.white),
                  ),
                ),
                textStyle: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              focusedPinTheme: const PinTheme(
                width: 30,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 36, 36, 36),
                  backgroundBlendMode: BlendMode.color,
                  border: Border(
                    bottom: BorderSide(color: Colors.white),
                  ),
                ),
                textStyle: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              resentButton ? "${initialMinutes.toString().padLeft(2, '0')} : ${initialSeconds.toString().padLeft(2, '0')}" : "${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't receive the code?",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      resentButtonColor = Colors.white;
                    });

                    if (resentButton) {
                      resentOTP();
                    }
                  },
                  onTapUp: (_) {
                    setState(() {
                      resentButtonColor = const Color.fromRGBO(46, 119, 255, 1);
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      resentButtonColor = const Color.fromRGBO(46, 119, 255, 1);
                    });
                  },
                  child: Text(
                    " Resend code",
                    style: TextStyle(
                      color: resentButtonColor,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
