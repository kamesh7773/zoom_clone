import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class EmailOtpVerificationPage extends StatefulWidget {
  const EmailOtpVerificationPage({super.key});

  @override
  State<EmailOtpVerificationPage> createState() => _EmailOtpVerificationPageState();
}

class _EmailOtpVerificationPageState extends State<EmailOtpVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      //! AppBar
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
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(46, 119, 255, 1),
          ),
        ),
      ),
      body: const Center(
        child: Column(
          children: [
            SizedBox(height: 52),
            Text(
              "Check your email for a code",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Please enter the verification code send to your email address kameshsinghaaa64@gmail.com",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //! Pinput Widget.
            Pinput(
              length: 6,
              
              keyboardType: TextInputType.number,
            ),
            Text(
              "09:53",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Did not get the code?",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Resend code",
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
