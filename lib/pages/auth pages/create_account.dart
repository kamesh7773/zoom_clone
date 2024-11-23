import 'package:colored_print/colored_print.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  // variable declaration
  final GlobalKey _formKey = GlobalKey<FormState>();
  Color createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
  Color createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
  bool viewPassword = false;

  // varible for password validation UI.
  bool allowConsecutiveWord = false;
  bool isEightChartors = false;
  bool atLeastOneNumber = false;
  bool atLeastOneLowercase = false;
  bool atLeastOneUppercase = false;

  // textediting controllar's
  TextEditingController firstNameControllar = TextEditingController();
  TextEditingController lastNameControllar = TextEditingController();
  TextEditingController passwordControllar = TextEditingController();

  // called every time when textediting controllar begin used and validate the entered password by user.
  void passwordValidator() {
    // if password texteding controllar is empty or validation for checking Consecutive/repeted Words are being used or not.
    if (passwordControllar.value.text.isNotEmpty && RegExp(r'(?:\d{4,}|([a-zA-Z])\1{3,}|0123|1234|2345|3456|4567|5678|6789|7890|0987|9876|8765|7654|6543|5432|4321|abcd|qwert|qwer|bcde|cdef|defg|efgh|fghi|ghij|ijkl|jklm|klmn|lmno|mnop|nopq|opqr|pqrs|qrst|rstu|stuv|tuvw|uvwx|vwxy|wxyz|aaaa|bbbb|cccc|dddd)').hasMatch(passwordControllar.value.text)) {
      setState(() {
        allowConsecutiveWord = false;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }
    if (passwordControllar.value.text.isNotEmpty && !RegExp(r'(?:\d{4,}|([a-zA-Z])\1{3,}|0123|1234|2345|3456|4567|5678|6789|7890|0987|9876|8765|7654|6543|5432|4321|abcd|qwert|qwer|bcde|cdef|defg|efgh|fghi|ghij|ijkl|jklm|klmn|lmno|mnop|nopq|opqr|pqrs|qrst|rstu|stuv|tuvw|uvwx|vwxy|wxyz|aaaa|bbbb|cccc|dddd)').hasMatch(passwordControllar.value.text)) {
      setState(() {
        allowConsecutiveWord = true;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }

    // validating atleast 8 chartors.
    if (!RegExp(r'^.{8,}$').hasMatch(passwordControllar.value.text)) {
      setState(() {
        isEightChartors = false;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }
    if (RegExp(r'^.{8,}$').hasMatch(passwordControllar.value.text)) {
      setState(() {
        isEightChartors = true;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }

    // validating at lest 1 number in password.
    if (!RegExp(r'.*\d+.*').hasMatch(passwordControllar.value.text)) {
      setState(() {
        atLeastOneNumber = false;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }
    if (RegExp(r'.*\d+.*').hasMatch(passwordControllar.value.text)) {
      setState(() {
        atLeastOneNumber = true;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }

    // validating at lest 1 lowercase in password.
    if (!RegExp(r'.*[a-z]+.*').hasMatch(passwordControllar.value.text)) {
      setState(() {
        atLeastOneLowercase = false;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }
    if (RegExp(r'.*[a-z]+.*').hasMatch(passwordControllar.value.text)) {
      setState(() {
        atLeastOneLowercase = true;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }

    // validating at lest 1 uppercase in password.
    if (!RegExp(r'.*[A-Z]+.*').hasMatch(passwordControllar.value.text)) {
      setState(() {
        atLeastOneUppercase = false;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }
    if (RegExp(r'.*[A-Z]+.*').hasMatch(passwordControllar.value.text)) {
      setState(() {
        atLeastOneUppercase = true;

        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }

    // when all condition where not applied then..
    if (passwordControllar.value.text.isNotEmpty && !RegExp(r'(?:\d{4,}|([a-zA-Z])\1{3,}|0123|1234|2345|3456|4567|5678|6789|7890|0987|9876|8765|7654|6543|5432|4321|abcd|qwert|qwer|bcde|cdef|defg|efgh|fghi|ghij|ijkl|jklm|klmn|lmno|mnop|nopq|opqr|pqrs|qrst|rstu|stuv|tuvw|uvwx|vwxy|wxyz|aaaa|bbbb|cccc|dddd)').hasMatch(passwordControllar.value.text) && RegExp(r'^.{8,}$').hasMatch(passwordControllar.value.text) && RegExp(r'.*\d+.*').hasMatch(passwordControllar.value.text) && RegExp(r'.*[a-z]+.*').hasMatch(passwordControllar.value.text) && RegExp(r'.*[A-Z]+.*').hasMatch(passwordControllar.value.text)) {
      ColoredPrint.warning("all condition where true");
      setState(() {
        allowConsecutiveWord = true;
        isEightChartors = true;
        atLeastOneNumber = true;
        atLeastOneLowercase = true;
        atLeastOneUppercase = true;

        createAccountButtonColor = const Color.fromARGB(255, 41, 116, 255);
        createAccountButtonTextColor = const Color.fromARGB(255, 255, 255, 255);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // method that listen the Textediting Controllar.
    passwordControllar.addListener(passwordValidator);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      //! AppBar
      appBar: AppBar(
        title: const Text(
          "Create account",
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
                      controller: firstNameControllar,
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
                      controller: lastNameControllar,
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
                          controller: passwordControllar,
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
              passwordControllar.value.text.isEmpty
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
                                  isEightChartors
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
                  onPressed: () {
                    if (passwordControllar.value.text.isEmpty) {
                    } else {}
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
