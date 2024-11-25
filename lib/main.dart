import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zoom_clone/routes/route_names.dart';
import 'package:zoom_clone/routes/routes.dart';
import 'package:zoom_clone/services/firebase_auth_methods.dart';
import 'package:zoom_clone/services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      // initialRoute: RoutesNames.homePage,
      onGenerateRoute: Routes.genrateRoute,
    );
  }
}
