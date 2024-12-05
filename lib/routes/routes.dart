import 'package:flutter/material.dart';
import 'package:zoom_clone/pages/basic%20pages/main_settings.dart';
import '../pages/auth%20pages/create_account.dart';
import '../pages/auth%20pages/email_otp_verification_page.dart';
import '../pages/auth%20pages/forgot_password_page.dart';
import '../pages/auth%20pages/sign_up_page_2.dart';
import '../pages/basic%20pages/home_page.dart';
import '../pages/basic%20pages/join_meeting_page.dart';
import '../pages/basic%20pages/meetings_screen.dart';
import '../pages/basic pages/welcome_settings_page.dart';
import '../pages/auth%20pages/sign_in_page.dart';
import '../pages/auth%20pages/sign_up_page_1.dart';
import '../pages/basic%20pages/splash_page.dart';
import '../pages/basic%20pages/start_meeting_page.dart';
import '../pages/basic%20pages/video_confrence_page.dart';
import '../pages/basic%20pages/welcome_page.dart';

import 'route_names.dart';

class Routes {
  static Route<dynamic> genrateRoute(RouteSettings settings) {
    switch (settings.name) {
      //! Splash Screen Page.
      case RoutesNames.splashPage:
        return MaterialPageRoute(
          builder: (context) => const SplashPage(),
        );

      //! Welcome Page.
      case RoutesNames.welcomePage:
        return MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        );

      //! Join Meeting Page.
      case RoutesNames.joinMeetingPage:
        return MaterialPageRoute(
          builder: (context) => const JoinMeetingPage(),
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

      //! Email OTP varification page.
      case RoutesNames.otpVarification:
        // Retriving BirthYear, Email, Fname, Lname and Password.
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (context) => OtpVerificationPage(
            birthYear: args["birthYear"],
            email: args["email"],
            fname: args["Fname"],
            lname: args["Lname"],
            password: args["password"],
          ),
        );

      //! Forgot Password Page.
      case RoutesNames.forgotPasswordPage:
        return MaterialPageRoute(
          builder: (context) => const ForgotPasswordPage(),
        );

      //! Video Conference Page.
      case RoutesNames.videoConferencePage:
        // Retriving BirthYear, Email, Fname, Lname and Password.
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (context) => VideoConferencePage(
            name: args["name"],
            userID: args["userID"],
            imageUrl: args["imageUrl"],
            conferenceID: args["conferenceID"],
            isVideoOn: args["isVideoOn"],
            isAudioOn: args["isAudioOn"],
          ),
        );

      //! Start Meeting Page.
      case RoutesNames.startMeetingPage:
        // Retriving the personalMeetingID.
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (context) => StartMeetingPage(
            personalMeetingID: args["personalMeetingID"],
          ),
        );

      //! Home Page.
      case RoutesNames.homePage:
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );

      //! MeetingScreen Page.
      case RoutesNames.meetingScreen:
        return MaterialPageRoute(
          builder: (context) => const MeetingScreen(),
        );

      //! Welcome Settings Page.
      case RoutesNames.welcomeSettingsPage:
        return MaterialPageRoute(
          builder: (context) => const WelcomeSettingsPage(),
        );

      //! Main Settings Page.
      case RoutesNames.mainSettingsPage:
        return MaterialPageRoute(
          builder: (context) => const MainSettings(),
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
