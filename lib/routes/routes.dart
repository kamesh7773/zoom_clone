import 'package:flutter/material.dart';
import 'package:zoom_clone/pages/auth%20pages/create_account.dart';
import 'package:zoom_clone/pages/auth%20pages/forgot_password_page.dart';
import 'package:zoom_clone/pages/auth%20pages/sign_up_page_2.dart';
import 'package:zoom_clone/pages/basic%20pages/home_page.dart';
import 'package:zoom_clone/pages/basic%20pages/join_meeting_page.dart';
import 'package:zoom_clone/pages/basic%20pages/settings_page.dart';
import 'package:zoom_clone/pages/auth%20pages/sign_in_page.dart';
import 'package:zoom_clone/pages/auth%20pages/sign_up_page_1.dart';
import 'package:zoom_clone/pages/basic%20pages/welcome_page.dart';

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

      //! SignUp Page 1.
      case RoutesNames.signUpPage_1:
        return MaterialPageRoute(
          builder: (context) => const SignUpPage1(),
        );

      //! SignUp Page 2.
      case RoutesNames.signUpPage_2:
        return MaterialPageRoute(
          builder: (context) => const SignUpPage2(),
        );

      //! create account page.
      case RoutesNames.createAccount:
        return MaterialPageRoute(
          builder: (context) => const CreateAccount(),
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
