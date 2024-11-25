import 'package:colored_print/colored_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  // varible declaration.
  Color resentButton = const Color.fromRGBO(46, 119, 255, 1);

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
                "Please enter the verification code send to your email address kameshsinghaaa64@gmail.com",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 26),
            //! Pinput Widget.
            Pinput(
              length: 6,
              keyboardType: TextInputType.number,
              onCompleted: (value) {},
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
            const Text(
              "00:00",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Did not get the code?",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      resentButton = Colors.white;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      resentButton = const Color.fromRGBO(46, 119, 255, 1);
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      resentButton = const Color.fromRGBO(46, 119, 255, 1);
                    });
                  },
                  child: Text(
                    " Resend code",
                    style: TextStyle(
                      color: resentButton,
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