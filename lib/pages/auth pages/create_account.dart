import 'package:flutter/material.dart';

import '../../services/firebase_auth_methods.dart';
import '../../utils/internet_checker.dart';
import '../../widgets/diolog_box.dart';

class CreateAccount extends StatefulWidget {
  final String birthYear;
  final String email;
  const CreateAccount({
    super.key,
    required this.email,
    required this.birthYear,
  });

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  // Variable declarations
  final GlobalKey _formKey = GlobalKey<FormState>();
  Color createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
  Color createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
  bool viewPassword = false;

  // Variables for password validation UI
  bool allowConsecutiveWord = false; // Indicates if consecutive words are allowed
  bool isEightCharacters = false; // Checks if the password has at least 8 characters
  bool atLeastOneNumber = false; // Checks if the password contains at least one number
  bool atLeastOneLowercase = false; // Checks if the password contains at least one lowercase letter
  bool atLeastOneUppercase = false; // Checks if the password contains at least one uppercase letter
  bool isPasswordVerified = false; // Indicates if the password meets all criteria

  // Text editing controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //? -----------------------
  //? Method for Email SignUp
  //? -----------------------

  void signUpMethod() {
    FirebaseAuthMethods.signUpWithEmail(
      birthYear: widget.birthYear,
      email: widget.email,
      fname: firstNameController.value.text.trim(),
      lname: lastNameController.value.text.trim(),
      password: passwordController.value.text.trim(),
      context: context,
    );
  }

  // Validates the password every time a text editing controller is used
  void passwordValidator() {
    // Check if the first name, last name, and password fields are empty or if the password contains consecutive/repeated characters
    if (firstNameController.value.text.isEmpty && lastNameController.value.text.isEmpty && passwordController.value.text.isEmpty && 
        RegExp(r'(?:\d{4,}|([a-zA-Z])\1{3,}|0123|1234|2345|3456|4567|5678|6789|7890|0987|9876|8765|7654|6543|5432|4321|abcd|qwert|qwer|bcde|cdef|defg|efgh|fghi|ghij|ijkl|jklm|klmn|lmno|mnop|nopq|opqr|pqrs|qrst|rstu|stuv|tuvw|uvwx|vwxy|wxyz|aaaa|bbbb|cccc|dddd)').hasMatch(passwordController.value.text)) {
      setState(() {
        allowConsecutiveWord = false;
        isPasswordVerified = false;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }
    if (RegExp(r'(?:\d{4,}|([a-zA-Z])\1{3,}|0123|1234|2345|3456|4567|5678|6789|7890|0987|9876|8765|7654|6543|5432|4321|abcd|qwert|qwer|bcde|cdef|defg|efgh|fghi|ghij|ijkl|jklm|klmn|lmno|mnop|nopq|opqr|pqrs|qrst|rstu|stuv|tuvw|uvwx|vwxy|wxyz|aaaa|bbbb|cccc|dddd)').hasMatch(passwordController.value.text)) {
      setState(() {
        allowConsecutiveWord = false;
        isPasswordVerified = false;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }
    if (passwordController.value.text.isNotEmpty && !RegExp(r'(?:\d{4,}|([a-zA-Z])\1{3,}|0123|1234|2345|3456|4567|5678|6789|7890|0987|9876|8765|7654|6543|5432|4321|abcd|qwert|qwer|bcde|cdef|defg|efgh|fghi|ghij|ijkl|jklm|klmn|lmno|mnop|nopq|opqr|pqrs|qrst|rstu|stuv|tuvw|uvwx|vwxy|wxyz|aaaa|bbbb|cccc|dddd)').hasMatch(passwordController.value.text)) {
      setState(() {
        allowConsecutiveWord = true;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }

    // validating atleast 8 chartors.
    if (!RegExp(r'^.{8,}$').hasMatch(passwordController.value.text)) {
      setState(() {
        isEightCharacters = false;
        isPasswordVerified = false;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }
    if (RegExp(r'^.{8,}$').hasMatch(passwordController.value.text)) {
      setState(() {
        isEightCharacters = true;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }

    // validating at lest 1 number in password.
    if (!RegExp(r'.*\d+.*').hasMatch(passwordController.value.text)) {
      setState(() {
        atLeastOneNumber = false;
        isPasswordVerified = false;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }
    if (RegExp(r'.*\d+.*').hasMatch(passwordController.value.text)) {
      setState(() {
        atLeastOneNumber = true;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }

    // validating at lest 1 lowercase in password.
    if (!RegExp(r'.*[a-z]+.*').hasMatch(passwordController.value.text)) {
      setState(() {
        atLeastOneLowercase = false;
        isPasswordVerified = false;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }
    if (RegExp(r'.*[a-z]+.*').hasMatch(passwordController.value.text)) {
      setState(() {
        atLeastOneLowercase = true;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }

    // validating at lest 1 uppercase in password.
    if (!RegExp(r'.*[A-Z]+.*').hasMatch(passwordController.value.text)) {
      setState(() {
        atLeastOneUppercase = false;
        isPasswordVerified = false;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }
    if (RegExp(r'.*[A-Z]+.*').hasMatch(passwordController.value.text)) {
      setState(() {
        atLeastOneUppercase = true;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }

    // When all conditions are met
    if (firstNameController.value.text.isNotEmpty && lastNameController.value.text.isNotEmpty && passwordController.value.text.isNotEmpty && 
        !RegExp(r'(?:\d{4,}|([a-zA-Z])\1{3,}|0123|1234|2345|3456|4567|5678|6789|7890|0987|9876|8765|7654|6543|5432|4321|abcd|qwert|qwer|bcde|cdef|defg|efgh|fghi|ghij|ijkl|jklm|klmn|lmno|mnop|nopq|opqr|pqrs|qrst|rstu|stuv|tuvw|uvwx|vwxy|wxyz|aaaa|bbbb|cccc|dddd)').hasMatch(passwordController.value.text) && 
        RegExp(r'^.{8,}$').hasMatch(passwordController.value.text) && 
        RegExp(r'.*\d+.*').hasMatch(passwordController.value.text) && 
        RegExp(r'.*[a-z]+.*').hasMatch(passwordController.value.text) && 
        RegExp(r'.*[A-Z]+.*').hasMatch(passwordController.value.text)) {
      setState(() {
        allowConsecutiveWord = true;
        isEightCharacters = true;
        atLeastOneNumber = true;
        atLeastOneLowercase = true;
        atLeastOneUppercase = true;
        isPasswordVerified = true;

        createAccountButtonColor = const Color.fromARGB(255, 41, 116, 255);
        createAccountButtonTextColor = const Color.fromARGB(255, 255, 255, 255);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // method that listen the Textediting Controllar's.
    firstNameController.addListener(passwordValidator);
    lastNameController.addListener(passwordValidator);
    passwordController.addListener(passwordValidator);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      //! AppBar
      appBar: AppBar(
        title: const Text(
          "Create account",
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
                  "Enter your name and set a password",
                  style: TextStyle(
                    color: Color.fromARGB(255, 168, 168, 168),
                    fontSize: 14,
                    fontFamily: "Lato",
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 36, 36, 36),
                  border: Border(
                    top: BorderSide(
                      width: 0.5,
                      color: Color.fromARGB(255, 85, 85, 85),
                    ),
                    bottom: BorderSide(
                      width: 0.7,
                      color: Color.fromARGB(255, 85, 85, 85),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    //! First Name Textediting Controller
                    TextFormField(
                      autofocus: true,
                      controller: firstNameController,
                      cursorColor: Colors.lightBlue,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: "First name",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 124, 123, 123)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                    //! Last Name Textediting Controller
                    TextFormField(
                      controller: lastNameController,
                      cursorColor: Colors.lightBlue,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: "Last name",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 124, 123, 123)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                    //! Password Textediting Controller
                    Stack(
                      children: [
                        TextFormField(
                          controller: passwordController,
                          cursorColor: Colors.lightBlue,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                          obscureText: viewPassword,
                          decoration: const InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: Color.fromARGB(255, 124, 123, 123)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  viewPassword = !viewPassword;
                                });
                              },
                              icon: viewPassword
                                  ? const Icon(
                                      Icons.remove_red_eye,
                                      size: 22,
                                      color: Color.fromARGB(255, 117, 117, 117),
                                    )
                                  : const Icon(
                                      Icons.visibility_off_outlined,
                                      size: 22,
                                      color: Color.fromARGB(255, 117, 117, 117),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // if password feild is empty then return this under widget.
              passwordController.value.text.isEmpty
                  ? const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //! Password validation warnings.
                        Padding(
                          padding: EdgeInsets.only(left: 25, top: 10),
                          child: Text(
                            "Password must inclued at least:",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "·   8 characters",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 166, 163, 163),
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "·   1 number",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 166, 163, 163),
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "·   1 lowercase letter",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 166, 163, 163),
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "·   1 uppercase",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 166, 163, 163),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 25, top: 14),
                          child: Text(
                            "Password must not include:",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            '·   4 or more consecutive or repeted characters\n    (Examples :"1234", "abcd", "1111" or "qwert")',
                            style: TextStyle(
                              color: Color.fromARGB(255, 166, 163, 163),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    )

                  // if password feild is not empty then we show the validation warnings & rules.
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //! Password validation warnings.
                        const Padding(
                          padding: EdgeInsets.only(left: 25, top: 10),
                          child: Text(
                            "Password must inclued at least:",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //! 8 characters.
                              Row(
                                children: [
                                  isEightCharacters
                                      ? const Icon(
                                          Icons.verified,
                                          size: 15,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.cancel,
                                          size: 15,
                                          color: Colors.red,
                                        ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    "8 characters",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 166, 163, 163),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              //! 1 Numbers.
                              Row(
                                children: [
                                  atLeastOneNumber
                                      ? const Icon(
                                          Icons.verified,
                                          size: 15,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.cancel,
                                          size: 15,
                                          color: Colors.red,
                                        ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    "1 number",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 166, 163, 163),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              //! 1 LowerCase letter.
                              Row(
                                children: [
                                  atLeastOneLowercase
                                      ? const Icon(
                                          Icons.verified,
                                          size: 15,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.cancel,
                                          size: 15,
                                          color: Colors.red,
                                        ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    "1 lowercase letter",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 166, 163, 163),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              //! 1 uppercase letter.
                              Row(
                                children: [
                                  atLeastOneUppercase
                                      ? const Icon(
                                          Icons.verified,
                                          size: 15,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.cancel,
                                          size: 15,
                                          color: Colors.red,
                                        ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    "1 uppercase",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 166, 163, 163),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 25, top: 14),
                          child: Text(
                            "Password must not include:",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              allowConsecutiveWord
                                  ? const Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: Icon(
                                        Icons.verified,
                                        size: 15,
                                        color: Colors.green,
                                      ),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: Icon(
                                        Icons.cancel,
                                        size: 15,
                                        color: Colors.red,
                                      ),
                                    ),
                              const SizedBox(width: 5),
                              const Text(
                                '4 or more consecutive or repeted characters\n(Examples :"1234", "abcd", "1111" or "qwert")',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 166, 163, 163),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 40),
              //! Sing In Button.
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    minimumSize: const Size(370, 46),
                    backgroundColor: createAccountButtonColor,
                  ),
                  onPressed: () async {
                    // First we check the Validation (if validation approved then..)
                    if (isPasswordVerified && firstNameController.value.text.isNotEmpty && lastNameController.value.text.isNotEmpty) {
                      // Check internet connection before proceeding
                      bool isInternet = await InternetChecker.checkInternet();

                      // Then we check the If internet is present (if internet is not available then..)
                      if (isInternet && context.mounted) {
                        PopUpWidgets.diologbox(
                          context: context,
                          title: "Sign up failed",
                          content: "Connection failed. Please check your network connection and try again.",
                        );
                      }
                      // if internet is present
                      else {
                        signUpMethod();
                      }
                    }
                  },
                  child: Text(
                    "Create account",
                    style: TextStyle(
                      fontSize: 16,
                      color: createAccountButtonTextColor,
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
