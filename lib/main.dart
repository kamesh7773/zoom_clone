import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:zoom_clone/pages/home_page.dart';
import 'package:zoom_clone/pages/login_page.dart';
import 'package:zoom_clone/services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zoom Clone',
      home: LoginPage(),
    );
  }
}
