import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../routes/route_names.dart';

class SignUpPage1 extends StatefulWidget {
  const SignUpPage1({super.key});

  @override
  State<SignUpPage1> createState() => _SignUpPageState1();
}

class _SignUpPageState1 extends State<SignUpPage1> {
  // Variable declarations
  final GlobalKey _formKey = GlobalKey<FormState>();
  Color continueButtonColor = const Color.fromARGB(255, 53, 52, 52);
  Color continueButtonTextColor = const Color.fromARGB(255, 124, 123, 123);

  // TextEditingController for birth year input
  late TextEditingController birthYearController;

  // This method is called whenever the TextEditingController is used.
  // It validates the birth year and updates the continue button's appearance based on the validation result.
  listenBirthYearTextEditingController() {
    if (RegExp(r'^(19[0-9]{2}|20[0-9]{2}|21[0-9]{2})$').hasMatch(birthYearController.value.text) && birthYearController.value.text.isNotEmpty) {
      setState(() {
        continueButtonColor = const Color.fromARGB(255, 41, 116, 255);
        continueButtonTextColor = const Color.fromARGB(255, 255, 255, 255);
      });
    } else {
      setState(() {
        continueButtonColor = const Color.fromARGB(255, 53, 52, 52);
        continueButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    birthYearController = TextEditingController();
    // Add a listener to the TextEditingController to monitor changes.
    birthYearController.addListener(listenBirthYearTextEditingController);
  }

  @override
  void dispose() {
    birthYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (value, result) {
        // Redirect the user to the Welcome Page when the back button is pressed.
        if (!value) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesNames.welcomePage,
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        //! AppBar
        appBar: AppBar(
          title: const Text(
            "Sign up",
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
              //! On press redirect user to Welcome Page.
              Navigator.of(context).pushNamedAndRemoveUntil(
                RoutesNames.welcomePage,
                (Route<dynamic> route) => false,
              );
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
                const Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(
                    "Verify your age",
                    style: TextStyle(
                      color: Color.fromARGB(255, 168, 168, 168),
                      fontSize: 14,
                      fontFamily: "Lato",
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                //! Birth Year TextEditingController
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 36, 36, 36),
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
                    autofocus: true,
                    controller: birthYearController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.lightBlue,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      hintText: "Birth year",
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
                      "Please confirm your birth year, This data will not be stored",
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Color.fromARGB(255, 168, 168, 168),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                //! Continue Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      minimumSize: const Size(370, 46),
                      backgroundColor: continueButtonColor,
                    ),
                    onPressed: () {
                      // If the birth year is valid, navigate to the next page.
                      if (RegExp(r'^(19[0-9]{2}|20[0-9]{2}|21[0-9]{2})$').hasMatch(birthYearController.value.text) && birthYearController.value.text.isNotEmpty) {
                        Navigator.of(context).pushNamed(
                          RoutesNames.signUpPage_2,
                          arguments: birthYearController.value.text,
                        );
                      }
                    },
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16,
                        color: continueButtonTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
