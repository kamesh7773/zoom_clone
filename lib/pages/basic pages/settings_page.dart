import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../routes/route_names.dart';
import '../../services/firebase_auth_methods.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Checking if the user is already logged in
  bool isUserAuthenticated = false;

  Future<void> isUserAuthenticate() async {
    isUserAuthenticated = await FirebaseAuthMethods.isUserLogin();
  }

  @override
  void initState() {
    super.initState();
    isUserAuthenticate();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (value, result) {
        if (!value) {
          //! On press redirect user to Welcome Page.
          Navigator.of(context).pushNamedAndRemoveUntil(
            isUserAuthenticated ? RoutesNames.homePage : RoutesNames.welcomePage,
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        //! AppBar
        appBar: AppBar(
          title: const Text(
            "More",
            style: TextStyle(
              fontSize: 19,
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
                isUserAuthenticated ? RoutesNames.homePage : RoutesNames.welcomePage,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //! Settings Heading.
              Container(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 20.0,
                  left: 28.0,
                  right: 8.0,
                ),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 36, 36, 36),
                  border: Border(
                    top: BorderSide(
                      width: 0.3,
                      color: Color.fromARGB(255, 131, 131, 131),
                    ),
                    bottom: BorderSide(
                      width: 0.3,
                      color: Color.fromARGB(255, 131, 131, 131),
                    ),
                  ),
                ),
                child: const Text(
                  "SETTINGS",
                  style: TextStyle(
                    color: Color.fromARGB(255, 161, 161, 161),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              //! Meetings Button.
              InkWell(
                overlayColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 46, 46, 46),
                ),
                onTap: () {},
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 12.0,
                        left: 32.0,
                        bottom: 12.0,
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.video,
                        size: 21,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(flex: 1),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 12.0,
                        bottom: 12.0,
                      ),
                      child: Text(
                        "Meetings",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Spacer(flex: 12),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 14.0,
                        right: 30.0,
                        bottom: 10.0,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        textDirection: TextDirection.rtl,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              //! Genral Settings Button.
              InkWell(
                overlayColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 46, 46, 46),
                ),
                onTap: () {},
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        left: 30.0,
                        bottom: 8.0,
                      ),
                      child: Icon(
                        Icons.settings_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Spacer(flex: 1),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 12.0,
                        bottom: 12.0,
                      ),
                      child: Text(
                        "General",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Spacer(flex: 12),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 14.0,
                        right: 30.0,
                        bottom: 14.0,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        textDirection: TextDirection.rtl,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              //! Accessibility Button.
              InkWell(
                overlayColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 46, 46, 46),
                ),
                onTap: () {},
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        left: 30.0,
                        bottom: 8.0,
                      ),
                      child: Icon(
                        Icons.accessibility,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Spacer(flex: 1),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 12.0,
                        bottom: 12.0,
                      ),
                      child: Text(
                        "Accessibility",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Spacer(flex: 12),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 14.0,
                        right: 30.0,
                        bottom: 14.0,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        textDirection: TextDirection.rtl,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              //! Version Section.
              InkWell(
                overlayColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 46, 46, 46),
                ),
                onTap: () {},
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        left: 20.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        "Version",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 12.0,
                        bottom: 12.0,
                        right: 8.0,
                      ),
                      child: Text(
                        "0.0.1",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 14.0,
                        right: 30.0,
                        bottom: 14.0,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        textDirection: TextDirection.rtl,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                indent: 18,
                endIndent: 18,
                thickness: 0.14,
                height: 0,
              ),
              //! Tell others about zoom.
              InkWell(
                overlayColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 46, 46, 46),
                ),
                onTap: () {},
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        left: 20.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        "Tell others about zoom",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 14.0,
                        right: 30.0,
                        bottom: 14.0,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        textDirection: TextDirection.rtl,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                indent: 18,
                endIndent: 18,
                thickness: 0.3,
                height: 0,
              ),
              //! Rate Zoom Workplace in the Google Play Store
              InkWell(
                overlayColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 46, 46, 46),
                ),
                onTap: () {},
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        left: 20.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        "Rate Zoom Workplace in the Google PlayStore",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 14.0,
                        bottom: 14.0,
                        right: 30.0,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        textDirection: TextDirection.rtl,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                indent: 18,
                endIndent: 18,
                thickness: 0.2,
                height: 0,
              ),
              //! Privacy Policy.
              InkWell(
                overlayColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 46, 46, 46),
                ),
                onTap: () {},
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        left: 20.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 14.0,
                        right: 30.0,
                        bottom: 14.0,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        textDirection: TextDirection.rtl,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                indent: 18,
                endIndent: 18,
                thickness: 0.3,
                height: 0,
              ),
              //! Term of Service.
              InkWell(
                overlayColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 46, 46, 46),
                ),
                onTap: () {},
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        left: 20.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        "Term of Service",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 14.0,
                        right: 30.0,
                        bottom: 14.0,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        textDirection: TextDirection.rtl,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                indent: 18,
                endIndent: 18,
                thickness: 0.3,
                height: 0,
              ),
              //! Community standards.
              InkWell(
                overlayColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 46, 46, 46),
                ),
                onTap: () {},
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        left: 20.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        "Community standards",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 14.0,
                        right: 30.0,
                        bottom: 14.0,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        textDirection: TextDirection.rtl,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                indent: 18,
                endIndent: 18,
                thickness: 0.2,
                height: 0,
              ),
              //! Open source software.
              const Padding(
                padding: EdgeInsets.only(left: 32.0, top: 16, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      "Open source software",
                      style: TextStyle(
                        color: Color.fromRGBO(46, 119, 255, 1),
                      ),
                    ),
                    SizedBox(width: 4),
                    FaIcon(
                      FontAwesomeIcons.arrowUpRightFromSquare,
                      color: Color.fromRGBO(46, 119, 255, 1),
                      size: 12,
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 0.2,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 10.0, top: 24),
                child: Text(
                  "Copyright ©2012-2024 Zoom Video Communications, lnc. All rights reserved.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
