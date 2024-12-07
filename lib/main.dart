import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'routes/route_names.dart';
import 'routes/routes.dart';
import 'services/firebase_auth_methods.dart';
import 'services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initlization.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Important code for Facebook sign-in/sign-up for Flutter web apps only
  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "448008428320311",
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );
  }

  // Checking if the user is already logged in
  bool isUserAuthenticated = await FirebaseAuthMethods.isUserLogin();

  runApp(MyApp(
    isUserAuthenticated: isUserAuthenticated,
  ));
}

class MyApp extends StatelessWidget {
  final bool isUserAuthenticated;
  const MyApp({super.key, required this.isUserAuthenticated});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zoom Clone',
      initialRoute: isUserAuthenticated ? RoutesNames.homePage : RoutesNames.welcomePage,
      onGenerateRoute: Routes.genrateRoute,
    );
  }
}
