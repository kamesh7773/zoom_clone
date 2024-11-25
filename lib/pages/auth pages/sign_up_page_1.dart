import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoom_clone/routes/route_names.dart';

class SignUpPage1 extends StatefulWidget {
  const SignUpPage1({super.key});

  @override
  State<SignUpPage1> createState() => _SignUpPageState1();
}

class _SignUpPageState1 extends State<SignUpPage1> {
  // variable declaration
  final GlobalKey _formKey = GlobalKey<FormState>();
  Color continueButtonColor = const Color.fromARGB(255, 53, 52, 52);
  Color continueButtonTextColor = const Color.fromARGB(255, 124, 123, 123);

  // textediting controllar's
  TextEditingController birthYearControllar = TextEditingController();

  // called every time when textediting controllar begin used.
  // Here we also validate the birth year textediting controllar for accepting the right birty year.
  listenPasswordTextEditingControllar() {
    if (RegExp(r'^(19[0-9]{2}|20[0-9]{2}|21[0-9]{2})$').hasMatch(birthYearControllar.value.text) && birthYearControllar.value.text.isNotEmpty) {
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
    // method that listen the Textediting Controllar.
    birthYearControllar.addListener(listenPasswordTextEditingControllar);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (value, result) {
        //! On press redirect user to Welcome Page.
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
                //! Birth year Textediting Controller
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
                    controller: birthYearControllar,
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
                //! Sing In Button.
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      minimumSize: const Size(370, 46),
                      backgroundColor: continueButtonColor,
                    ),
                    onPressed: () {
                      // If birth year is not validated.
                      if (!RegExp(r'^(19[0-9]{2}|20[0-9]{2}|21[0-9]{2})$').hasMatch(birthYearControllar.value.text) && birthYearControllar.value.text.isNotEmpty) {
                      }
                      // If it is got validated.
                      else {
                        Navigator.of(context).pushNamed(
                          RoutesNames.signUpPage_2,
                          //! passing the BirthYear to SignUp 2 Page.
                          arguments: birthYearControllar.value.text,
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
