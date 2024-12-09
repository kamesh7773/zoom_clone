import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../routes/route_names.dart';
import '../../services/firebase_auth_methods.dart';

class MainSettings extends StatefulWidget {
  const MainSettings({super.key});

  @override
  State<MainSettings> createState() => _MainSettingsPageState();
}

class _MainSettingsPageState extends State<MainSettings> {
  //! This method masks/hides the user's email
  String maskEmail(String email) {
    if (!email.contains('@')) return email; // Return as is if not a valid email

    final parts = email.split('@');
    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 3) {
      // If the username is too short, mask all but the first character
      return '${username.substring(0, 1)}***@$domain';
    }

    // Mask all but the first three characters of the username
    return '${username.substring(0, 3)}***@$domain';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (value, result) {
        if (!value) {
          //! Redirects the user to the home page when pressed.
          Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesNames.homePage,
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
              //! On press redirect user to homePage.
              Navigator.of(context).pushNamedAndRemoveUntil(
                RoutesNames.homePage,
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
              //! -------------------
              //! Upgrade now saction
              //! -------------------
              Container(
                width: double.infinity,
                height: 70,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 46, 45, 45),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      height: 30,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple,
                            Colors.blue,
                            Color.fromARGB(255, 89, 255, 125),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Upgrade now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Try Zoom Workplace Pro",
                      style: TextStyle(
                        color: Color.fromRGBO(55, 125, 255, 1),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              //! ---------------
              //! Profile Saction
              //! ---------------
              FutureBuilder<Map<String, dynamic>?>(
                future: FirebaseAuthMethods.getUserData(),
                builder: (context, snapshot) {
                  // if data is being loaded..
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      height: 90,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Color.fromARGB(255, 59, 58, 58),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                        ),
                      ),
                    );
                  }

                  // if snapshot has Data.
                  if (snapshot.hasData) {
                    final Map<String, dynamic>? userData = snapshot.data;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      height: 90,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Color.fromARGB(255, 59, 58, 58),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 16),
                              //! profile Picture.
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  fit: BoxFit.fitHeight,
                                  width: 50,
                                  height: 50,
                                  imageUrl: userData?["imageUrl"],
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(width: 14),
                              //! Name and BASIC  ||  Provider logo and Gmail
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userData?["name"],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            "BASIC",
                                            style: TextStyle(
                                              color: Color.fromRGBO(55, 125, 255, 1),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          //! If provider is "Google" then..
                                          if (userData?["provider"] == "Google")
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.asset(
                                                width: 16,
                                                height: 16,
                                                "assets/images/google.png",
                                              ),
                                            ),
                                          //! If provider is "Facebook" then..
                                          if (userData?["provider"] == "Facebook")
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.asset(
                                                width: 16,
                                                height: 16,
                                                "assets/images/facebook.png",
                                              ),
                                            ),
                                          //! If provider is "Twitter" then..
                                          if (userData?["provider"] == "Twitter")
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.asset(
                                                width: 16,
                                                height: 16,
                                                "assets/images/x.png",
                                              ),
                                            ),
                                          //! If provider is "Email & Password" then..
                                          if (userData?["provider"] == "Email & Password")
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.asset(
                                                color: Colors.white,
                                                width: 16,
                                                height: 16,
                                                "assets/images/Email.png",
                                              ),
                                            ),
                                          const SizedBox(width: 4),
                                          if (RenderObject.debugCheckingIntrinsics) const SizedBox(width: 10),
                                          Text(
                                            maskEmail(userData?["email"]),
                                            style: const TextStyle(
                                              color: Color.fromARGB(255, 147, 137, 137),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //! QR CODE Image
                              Container(
                                margin: const EdgeInsets.only(right: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  color: Colors.black,
                                ),
                                child: Image.asset(
                                  width: 22,
                                  height: 22,
                                  color: Colors.white,
                                  "assets/images/QR_Code.png",
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  // else return nothing.

                  else {
                    return const Center(
                      child: Text("Loading..."),
                    );
                  }
                },
              ),

              //! --------------------
              //! Added Feture Saction
              //! --------------------
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
                    bottom: BorderSide(
                      width: 0.3,
                      color: Color.fromARGB(255, 131, 131, 131),
                    ),
                  ),
                ),
                child: const Text(
                  "ADDED FEATURES",
                  style: TextStyle(
                    color: Color.fromARGB(255, 161, 161, 161),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              //! whiteboard.
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
                        FontAwesomeIcons.chalkboard,
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
                        "Whiteboards",
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
              //! Events.
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
                        FontAwesomeIcons.calendar,
                        size: 23,
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
                        "Events",
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
              //! Apps.
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
                        FontAwesomeIcons.uncharted,
                        size: 23,
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
                        "Apps",
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
              //! Contancts.
              InkWell(
                overlayColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 46, 46, 46),
                ),
                onTap: () {},
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                        left: 30.0,
                        bottom: 12.0,
                      ),
                      child: Icon(
                        Icons.person_outline_outlined,
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
                        "Contacts",
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
              //! Clips Button.
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
                        left: 28.0,
                        bottom: 12.0,
                      ),
                      child: Icon(
                        Icons.media_bluetooth_on_rounded,
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
                        "Clips",
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
              //! Notes Button.
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
                        FontAwesomeIcons.noteSticky,
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
                        "Notes",
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
              //! Docs Button.
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
                      child: Icon(
                        Icons.note_add_sharp,
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
                        "Docs",
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

              //! ----------------
              //! Settings Heading
              //! ----------------
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
              //! Team Chat Button.
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
                      child: Icon(
                        Icons.chat_bubble_outline_sharp,
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
                        "Team Chat",
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
              //! Notification Button.
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
                        left: 30.0,
                        bottom: 12.0,
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
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
                        "Notifications",
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

              //! ----------------
              //! Other Heading
              //! ----------------
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
                  "OTHER",
                  style: TextStyle(
                    color: Color.fromARGB(255, 161, 161, 161),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

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
                        left: 30.0,
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
                        left: 30.0,
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
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 8.0,
                          left: 30.0,
                          bottom: 8.0,
                        ),
                        child: Text(
                          "Rate Zoom Workplace in the Google PlayStore",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
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
                child: const SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 8.0,
                          left: 30.0,
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
                        left: 30.0,
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
                        left: 30.0,
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
                padding: EdgeInsets.only(left: 32.0, top: 16, bottom: 20),
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
                height: 0,
              ),

              //! --------------
              //! LOGOUT SACTION
              //! --------------
              InkWell(
                onTap: () {
                  FirebaseAuthMethods.singOut(context: context);
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 15.0,
                    bottom: 15.0,
                    right: 8.0,
                  ),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 45, 45, 45),
                    border: Border(
                      bottom: BorderSide(
                        width: 0.3,
                        color: Color.fromARGB(255, 131, 131, 131),
                      ),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "LOGOUT",
                      style: TextStyle(
                        color: Color.fromARGB(255, 161, 161, 161),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
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
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
