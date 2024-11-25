import 'package:flutter/material.dart';
import 'package:zoom_clone/pages/auth%20pages/create_account.dart';
import 'package:zoom_clone/pages/auth%20pages/email_otp_verification_page.dart';
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
        // Retriving the BirthYear.
        final birthyear = settings.arguments as String;

        return MaterialPageRoute(
          builder: (context) => SignUpPage2(birthYear: birthyear),
        );

      //! create account page.
      case RoutesNames.createAccount:
        // Retriving BirthYear and Email.
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (context) => CreateAccount(
            birthYear: args["birtyYear"],
            email: args["email"],
          ),
        );

      //! create account page.
      case RoutesNames.otpVarification:
        return MaterialPageRoute(
          builder: (context) => const OtpVerificationPage(),
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
