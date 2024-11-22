import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:password_field_validator/password_field_validator.dart';

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

  // textediting controllar's
  TextEditingController firstNameControllar = TextEditingController();
  TextEditingController lastNameControllar = TextEditingController();
  TextEditingController passwordControllar = TextEditingController();

  // called every time when textediting controllar begin used.
  // Here we also validate the birth year textediting controllar for accepting the right birty year.
  listenPasswordTextEditingControllar() {
    if (RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(passwordControllar.value.text) && passwordControllar.value.text.isNotEmpty) {
      setState(() {
        createAccountButtonColor = const Color.fromARGB(255, 41, 116, 255);
        createAccountButtonTextColor = const Color.fromARGB(255, 255, 255, 255);
      });
    } else {
      setState(() {
        createAccountButtonColor = const Color.fromARGB(255, 53, 52, 52);
        createAccountButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // method that listen the Textediting Controllar.
    passwordControllar.addListener(listenPasswordTextEditingControllar);
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
              //! Password validation warnings.
              const Padding(
                padding: EdgeInsets.only(left: 6, top: 10),
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Text(
                    "Password must inclued at least:",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              PasswordFieldValidator(
                minLength: 8,
                uppercaseCharCount: 1,
                lowercaseCharCount: 1,
                numericCharCount: 1,
                specialCharCount: 1,
                defaultColor: Colors.white,
                successColor: Colors.green,
                failureColor: Colors.red,
                controller: passwordControllar,
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
