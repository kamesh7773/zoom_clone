import 'package:flutter/material.dart';
import 'package:zoom_clone/routes/route_names.dart';

class SignUpPage2 extends StatefulWidget {
  final String birthYear;
  const SignUpPage2({super.key, required this.birthYear});

  @override
  State<SignUpPage2> createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {
  // variable declaration
  final GlobalKey _formKey = GlobalKey<FormState>();
  Color signInButtonColor = const Color.fromARGB(255, 53, 52, 52);
  Color signInButtonTextColor = const Color.fromARGB(255, 124, 123, 123);

  // textediting controllar's
  TextEditingController emailControllar = TextEditingController();

  // called every time when textediting controllar begin used.
  // Here we also validate the email & password controllar if they get validated then only the sign in method get run.
  listenPasswordTextEditingControllar() {
    if (RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(emailControllar.value.text)) {
      setState(() {
        signInButtonColor = const Color.fromARGB(255, 41, 116, 255);
        signInButtonTextColor = const Color.fromARGB(255, 255, 255, 255);
      });
    } else {
      setState(() {
        signInButtonColor = const Color.fromARGB(255, 53, 52, 52);
        signInButtonTextColor = const Color.fromARGB(255, 124, 123, 123);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // method that listen the Textediting Controllar.
    emailControllar.addListener(listenPasswordTextEditingControllar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      //! AppBar
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
              const SizedBox(height: 8),
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
                      width: 0.5,
                      color: Color.fromARGB(255, 85, 85, 85),
                    ),
                  ),
                ),
                child: TextFormField(
                  controller: emailControllar,
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
              const SizedBox(height: 18),
              //! Sing In Button.
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    minimumSize: const Size(370, 46),
                    backgroundColor: signInButtonColor,
                  ),
                  onPressed: () {
                    //! If Email address verified.
                    if (RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(emailControllar.value.text)) {
                      Navigator.of(context).pushNamed(
                        RoutesNames.createAccount,
                        arguments: {
                          "birtyYear": widget.birthYear,
                          "email": emailControllar.value.text,
                        },
                      );
                    }
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: signInButtonTextColor,
                    ),
                  ),
                ),
              ),
              //! Forgot Password Button
              const Padding(
                padding: EdgeInsets.only(left: 14.0, top: 6.0),
                child: Wrap(
                  children: [
                    Text(
                      "By proceeding,I agree to the",
                      style: TextStyle(
                        color: Color.fromARGB(255, 136, 135, 135),
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      " Zoom's privacy Statement",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      " and",
                      style: TextStyle(
                        color: Color.fromARGB(255, 136, 135, 135),
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "Terms of Services",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              //! Other Sing in methods
              const Padding(
                padding: EdgeInsets.only(left: 12, top: 20),
                child: Text(
                  "Or select your sign up methods",
                  style: TextStyle(color: Color.fromARGB(255, 120, 118, 118), fontSize: 14),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    //! continue with google.
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                          color: Color.fromARGB(255, 255, 255, 255),
                          width: 0.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        fixedSize: const Size(370, 52),
                        backgroundColor: const Color.fromARGB(255, 55, 55, 55),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("assets/images/google.png"),
                          const Text(
                            "Continue with Google",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox()
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    //! Continue with Facebook.
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                          color: Color.fromARGB(255, 255, 255, 255),
                          width: 0.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        fixedSize: const Size(370, 52),
                        backgroundColor: const Color.fromARGB(255, 55, 55, 55),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/images/facebook.png",
                          ),
                          const Text(
                            "Continue with Faceboook",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox()
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    //! Continue with X.
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                          color: Color.fromARGB(255, 255, 255, 255),
                          width: 0.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        fixedSize: const Size(370, 52),
                        backgroundColor: const Color.fromARGB(255, 55, 55, 55),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("assets/images/x.png"),
                          const Text(
                            "Continue with X",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox()
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
