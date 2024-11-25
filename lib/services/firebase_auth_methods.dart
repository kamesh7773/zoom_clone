import 'package:colored_print/colored_print.dart';
import 'package:email_otp_auth/email_otp_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zoom_clone/routes/route_names.dart';
import 'package:zoom_clone/utils/diolog_box.dart';
import 'package:zoom_clone/utils/internet_checker.dart';
import 'package:zoom_clone/utils/progress_indicator.dart';

class FirebaseAuthMethods {
  // Variables related to Firebase instances
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --------------------
  // Email Authentication
  // --------------------

  //! Email & Password SignUp Method
  static Future<void> signUpWithEmail({
    required String birthYear,
    required String email,
    required String fname,
    required String lname,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Show Progress Indicator
      ProgressIndicators.showProgressIndicator(context);

      // Check if email exists with "Email & Password" provider in users collection
      QuerySnapshot queryForEmailAndProvider = await _db.collection('users').where("email", isEqualTo: email).where("provider", isEqualTo: "Email & Password").get();

      // If email already exists with Email & Password provider
      if (queryForEmailAndProvider.docs.isNotEmpty && context.mounted) {
        ColoredPrint.warning(" email address is already in used");
        Navigator.of(context).pop();
        PopUpWidgets.diologbox(
          context: context,
          title: "Email already used",
          content: "The email address is already in use by another account.",
        );
      }
      // If email doesn't exist or uses different provider
      else {
        if (context.mounted) {
          try {
            // Send OTP to user's email address
            await EmailOtpAuth.sendOTP(email: email);

            if (context.mounted) {
              Navigator.pop(context);
            }

            // Check internet connection before proceeding
            bool isInternet = await InternetChecker.checkInternet();

            // Show error if no internet connection
            if (isInternet && context.mounted) {
              PopUpWidgets.diologbox(
                context: context,
                title: "Sign up failed",
                content: "Connection failed. Please check your network connection and try again.",
              );
            }
            // If internet is available, redirect to OTP page
            else if (!isInternet && context.mounted) {
              Navigator.of(context).pushNamed(
                RoutesNames.otpVarification,
                arguments: {
                  "birthYear": birthYear,
                  "email": email,
                  "Fname": fname,
                  "Lname": lname,
                  "password": password,
                },
              );
            }
          } catch (error) {
            if (context.mounted) {
              ColoredPrint.warning(error.toString());
              Navigator.pop(context);
              PopUpWidgets.diologbox(
                context: context,
                title: "Network Error",
                content: error.toString(),
              );
            }
          }
        }
      }
    }
    // Handle Firebase Firestore Exceptions.
    on FirebaseException catch (error) {
      ColoredPrint.warning("error found");
      if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
        Navigator.popUntil(context, ModalRoute.withName("/SignUpPage"));
        PopUpWidgets.diologbox(
          context: context,
          title: "Email already used",
          content: "The email address is already in use by another account.",
        );
      } else {
        if (context.mounted) {
          Navigator.popUntil(context, ModalRoute.withName("/SignUpPage"));
          PopUpWidgets.diologbox(
            context: context,
            title: "Network Error",
            content: error.message!,
          );
        }
      }
    }
  }
}
