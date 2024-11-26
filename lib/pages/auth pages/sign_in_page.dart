import 'package:flutter/material.dart';
import 'package:zoom_clone/routes/route_names.dart';
import 'package:zoom_clone/services/firebase_auth_methods.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // variable declaration
  final GlobalKey _formKey = GlobalKey<FormState>();
  Color signInButtonColor = const Color.fromARGB(255, 53, 52, 52);
  Color signInButtonTextColor = const Color.fromARGB(255, 124, 123, 123);

  // textediting controllar's
  TextEditingController emailControllar = TextEditingController();
  TextEditingController passwordControllar = TextEditingController();

  //? ------------------
  //? Method for Sing IN
  //? ------------------

  void singIn() {
    FirebaseAuthMethods.signInWithEmail(
      email: emailControllar.value.text.trim(),
      password: passwordControllar.value.text.trim(),
      context: context,
    );
  }

  // called every time when textediting controllar begin used.
  // Here we also validate the email & password controllar if they get validated then only the sign in method get run.
  listenPasswordTextEditingControllar() {
    if (RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(emailControllar.value.text) && passwordControllar.value.text.isNotEmpty) {
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
    passwordControllar.addListener(listenPasswordTextEditingControllar);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        //! On press redirect user to Welcome Page.
        Navigator.of(context).pushNamedAndRemoveUntil(
          RoutesNames.welcomePage,
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
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
                        width: 0.25,
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
                  child: TextFormField(
                    controller: passwordControllar,
                    cursorColor: Colors.lightBlue,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
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
                      backgroundColor: signInButtonColor,
                    ),
                    onPressed: () {
                      if (RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(emailControllar.value.text) && passwordControllar.value.text.isNotEmpty) {
                        singIn();
                      }
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                        fontSize: 16,
                        color: signInButtonTextColor,
                      ),
                    ),
                  ),
                ),
                //! Forgot Password Button
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Navigator.of(context).pushNamed(RoutesNames.forgotPasswordPage);
                    },
                    splashColor: const Color.fromARGB(4, 56, 192, 255),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Color.fromRGBO(71, 135, 255, 1),
                        ),
                      ),
                    ),
                  ),
                ),
                //! Other Sing in methods
                const Padding(
                  padding: EdgeInsets.only(left: 12, top: 40),
                  child: Text(
                    "Other sign in methods",
                    style: TextStyle(color: Color.fromARGB(255, 147, 144, 144), fontSize: 14),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      //! continue with google.
                      ElevatedButton(
                        onPressed: () {
                          FirebaseAuthMethods.signInWithGoogle(context: context);
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255),
                            width: 0.12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          fixedSize: const Size(370, 52),
                          backgroundColor: const Color.fromARGB(255, 44, 44, 44),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/images/google.png"),
                            const Text(
                              "Continue with Google",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox()
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      //! Continue with Facebook.
                      ElevatedButton(
                        onPressed: () {
                          FirebaseAuthMethods.signInwithFacebook(context: context);
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255),
                            width: 0.12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          fixedSize: const Size(370, 52),
                          backgroundColor: const Color.fromARGB(255, 44, 44, 44),
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
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox()
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      //! Continue with X.
                      ElevatedButton(
                        onPressed: () {
                          FirebaseAuthMethods.singInwithTwitter(context: context);
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255),
                            width: 0.12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          fixedSize: const Size(370, 52),
                          backgroundColor: const Color.fromARGB(255, 44, 44, 44),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/images/x.png"),
                            const Text(
                              "Continue with X",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
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
      ),
    );
  }
}
