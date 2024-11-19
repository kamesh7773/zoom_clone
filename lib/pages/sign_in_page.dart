import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // variable declaration
  Color signInButtonColor = const Color.fromARGB(255, 53, 52, 52);
  Color signInButtonTextColor = const Color.fromARGB(255, 124, 123, 123);

  // textediting controllar's
  TextEditingController emailControllar = TextEditingController();
  TextEditingController passwordControllar = TextEditingController();

  // called every time when textediting controllar begin used.
  void listenPasswordTextEditingControllar() {
    if (passwordControllar.value.text.isNotEmpty) {
      setState(() {
        signInButtonColor = const Color.fromARGB(255, 41, 116, 255);
        signInButtonTextColor = const Color.fromARGB(255, 255, 255, 255);
      });
    }
    if (passwordControllar.value.text.isEmpty) {
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
    passwordControllar.addListener(listenPasswordTextEditingControllar);
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
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromRGBO(46, 119, 255, 1),
          ),
        ),
      ),
      body: Column(
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
            child: TextField(
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
            child: TextField(
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
                if (passwordControllar.value.text.isEmpty) {
                } else {}
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
              onTap: () {},
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
                      Image.asset("assets/images/apple.png"),
                      const Text(
                        "Continue with Apple",
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
              ],
            ),
          )
        ],
      ),
    );
  }
}