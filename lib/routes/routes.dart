import 'package:flutter/material.dart';
import 'package:zoom_clone/pages/auth%20pages/forgot_password_page.dart';
import 'package:zoom_clone/pages/home_page.dart';
import 'package:zoom_clone/pages/join_meeting_page.dart';
import 'package:zoom_clone/pages/settings_page.dart';
import 'package:zoom_clone/pages/auth%20pages/sign_in_page.dart';
import 'package:zoom_clone/pages/auth%20pages/sign_up_page_1.dart';
import 'package:zoom_clone/pages/welcome_page.dart';

import 'route_names.dart';

class Routes {
  static Route<dynamic> genrateRoute(RouteSettings settings) {
    switch (settings.name) {
      //! Welcome Page.
      case RoutesNames.welcomePage:
        return MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        );

      //! SignIn Page.
      case RoutesNames.signInPage:
        return MaterialPageRoute(
          builder: (context) => const SignInPage(),
        );

      //! SignUp Page.
      case RoutesNames.signUpPage:
        return MaterialPageRoute(
          builder: (context) => const SignUpPage(),
        );

      //! Forgot Password Page.
      case RoutesNames.forgotPasswordPage:
        return MaterialPageRoute(
          builder: (context) => const ForgotPasswordPage(),
        );

      //! Join Meeting Page.
      case RoutesNames.joinMeetingPage:
        return MaterialPageRoute(
          builder: (context) => const JoinMeetingPage(),
        );

      //! Home Page.
      case RoutesNames.homePage:
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );

      //! Settings Page.
      case RoutesNames.settingsPage:
        return MaterialPageRoute(
          builder: (context) => const SettingsPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text("No Route Found"),
            ),
          ),
        );
    }
  }
}
