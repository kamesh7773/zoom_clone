import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_clone/routes/route_names.dart';
import 'package:zoom_clone/services/email_auth_backend.dart';
import 'package:zoom_clone/widgets/diolog_box.dart';
import 'package:zoom_clone/utils/internet_checker.dart';
import 'package:zoom_clone/widgets/progress_indicator.dart';

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
          }
          //? Handling E-mail OTP error's
          catch (error) {
            if (error == "ClientException with SocketException: Failed host lookup: 'definite-emilee-kamesh-564a9766.koyeb.app' (OS Error: No address associated with hostname, errno = 7), uri=https://definite-emilee-kamesh-564a9766.koyeb.app/api/send-otp") {
              if (context.mounted) {
                // poping out the progress indicator
                Navigator.of(context).pop();

                PopUpWidgets.diologbox(
                  context: context,
                  title: "Network failure",
                  content: "Connection failed. Please check your network connection and try again.",
                );
              }
            } else {
              if (context.mounted) {
                // poping out the progress indicator
                Navigator.of(context).pop();

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
    }
    // Handle Firebase Firestore Exceptions.
    on FirebaseException catch (error) {
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

  //! Verify Email OTP and create user account
  static Future<void> verifyEmailOTP({
    required String birthYear,
    required String email,
    required String fname,
    required String lname,
    required String password,
    required emailOTP,
    required BuildContext context,
  }) async {
    // Try and Catch block for Email OTP Auth API.
    try {
      ProgressIndicators.showProgressIndicator(context);

      // Verify the email OTP
      var res = await EmailOtpAuth.verifyOtp(otp: emailOTP);

      // If OTP verification is successful, create user account and store data
      if (res["message"] == "OTP Verified") {
        // Try and Catch Block for Firebase Email Sign Up Auth.
        try {
          // Create user account in Firebase Auth
          await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Store user data in Firestore
          await _db.collection("users").doc(_auth.currentUser!.uid).set({
            "birthYear": birthYear,
            "name": "$fname $lname",
            "email": email,
            "provider": "Email & Password",
            "userID": _auth.currentUser!.uid,
          });

          // Fetch current user info from Firestore
          final currentUserInfo = await _db.collection("users").doc(_auth.currentUser!.uid).get();
          final userData = currentUserInfo.data();

          // Store user data in SharedPreferences
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("birthYear", userData!["birthYear"]);
          await prefs.setString("name", userData["name"]);
          await prefs.setString("email", userData["email"]);
          await prefs.setString("provider", userData["provider"]);
          await prefs.setString("userID", userData["userID"]);

          // Set login status
          await prefs.setBool('isLogin', true);

          // Redirect to HomePage after successful signup
          if (context.mounted) {
            Navigator.pop(context);
            Navigator.of(context).pushNamedAndRemoveUntil(
              RoutesNames.homePage,
              (Route<dynamic> route) => false,
            );
          }
        }
        // Handle Firebase Auth exceptions during account creation
        on FirebaseAuthException catch (error) {
          if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
            Navigator.of(context).pop();
            PopUpWidgets.diologbox(
              context: context,
              title: "Sign up failed",
              content: "Connection failed. Please check your network connection and try again.",
            );
          } else {
            if (context.mounted) {
              Navigator.of(context).pop();
              PopUpWidgets.diologbox(
                context: context,
                title: "Network Error",
                content: error.toString(),
              );
            }
          }
        }
      } else if (res["data"] == "Invalid OTP" && context.mounted) {
        Navigator.of(context).pop();
        PopUpWidgets.diologbox(
          context: context,
          title: "Invalid OTP",
          content: "It seems like the OTP is incorrect. Please try again or resend the OTP.",
        );
      } else if (res["data"] == "OTP Expired" && context.mounted) {
        Navigator.of(context).pop();
        PopUpWidgets.diologbox(
          context: context,
          title: "OTP Expired",
          content: "Your OTP has expired. Please request a new code to proceed.",
        );
      }
    }
    // Handle OTP verification errors
    catch (error) {
      if (error == "ClientException with SocketException: Failed host lookup: 'definite-emilee-kamesh-564a9766.koyeb.app' (OS Error: No address associated with hostname, errno = 7), uri=https://definite-emilee-kamesh-564a9766.koyeb.app/api/verify-otp") {
        if (context.mounted) {
          Navigator.pop(context);
          PopUpWidgets.diologbox(
            context: context,
            title: "Sign up failed",
            content: "Connection failed. Please check your network connection and try again.",
          );
        }
      } else {
        if (context.mounted) {
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

  //! Resend OTP on Email Method
  static Future<void> resentEmailOTP({required email, required BuildContext context}) async {
    try {
      // Showing the progress Indicator
      ProgressIndicators.showProgressIndicator(context);
      await EmailOtpAuth.sendOTP(email: email);
      // Poping of the Progress Indicator
      if (context.mounted) {
        Navigator.pop(context);

        PopUpWidgets.diologbox(
          context: context,
          title: "OTP sent",
          content: "Your OTP has been successfully sent to your registered email address. Kindly check your Gmail inbox",
        );
      }
    }
    //? Handling E-mail OTP error's
    catch (error) {
      if (error == "ClientException with SocketException: Failed host lookup: 'definite-emilee-kamesh-564a9766.koyeb.app' (OS Error: No address associated with hostname, errno = 7), uri=https://definite-emilee-kamesh-564a9766.koyeb.app/api/send-otp") {
        if (context.mounted) {
          // poping out the progress indicator
          Navigator.of(context).pop();

          PopUpWidgets.diologbox(
            context: context,
            title: "Network failure",
            content: "Connection failed. Please check your network connection and try again.",
          );
        }
      } else {
        if (context.mounted) {
          // poping out the progress indicator
          Navigator.of(context).pop();
        }
      }
    }
  }

  //! Email & Password Login Method
  static Future<void> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // showing CircularProgressIndicator
      ProgressIndicators.showProgressIndicator(context);

      // Method for sing in user with email & password
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // fetching current userId info from "users" collection.
      final currentUserInfo = await _db.collection("users").doc(_auth.currentUser!.uid).get();

      final userData = currentUserInfo.data();

      // creating instace of Shared Preferences.
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // writing current User info data to SharedPreferences.
      await prefs.setString("birthYear", userData!["birthYear"]);
      await prefs.setString("name", userData["name"]);
      await prefs.setString("email", userData["email"]);
      await prefs.setString("provider", userData["provider"]);
      await prefs.setString("userID", userData["userID"]);

      // setting isLogin to "true"
      await prefs.setBool('isLogin', true);

      // After login successfully redirecting user to HomePage
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.of(context).pushNamedAndRemoveUntil(
          RoutesNames.homePage,
          (Route<dynamic> route) => false,
        );
      }
    }
    // Handling Login auth Exceptions
    on FirebaseAuthException catch (error) {
      if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
        Navigator.pop(context);
        PopUpWidgets.diologbox(
          context: context,
          title: "Sign up failed",
          content: "Connection failed. Please check your network connection and try again.",
        );
      } else if (error.message == "The supplied auth credential is incorrect, malformed or has expired." && context.mounted) {
        Navigator.pop(context);
        PopUpWidgets.diologbox(
          context: context,
          title: "Invalid credentials",
          content: "Your entered email and password are Invalid. Please check your email & password and try again.",
        );
      } else {
        if (context.mounted) {
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

  //! Email & Password ForgorPassword/Reset Method
  static Future<bool> forgotEmailPassword({
    required String email,
    required BuildContext context,
  }) async {
    // variable declartion
    late bool associatedEmail;
    try {
      // showing Progress Indigator
      ProgressIndicators.showProgressIndicator(context);
      //* 1st We check if the entered email address is already present & its provider is "Email & Password" in the "users" collection by querying FireStore's "users" Collection.
      // searching for Email Address & "Email & Password" provider in "users" collection at once
      QuerySnapshot queryForEmailAndProvider = await _db.collection('users').where("email", isEqualTo: email).where("provider", isEqualTo: "Email & Password").get();

      // if the entered Email address already present in "users" collection and Provider is "Email & Password"
      // it's means that user is entered corrent email address it's mean we can send that Forgot password link to user Email Address.
      if (queryForEmailAndProvider.docs.isNotEmpty && context.mounted) {
        // Method for sending forgot password link to user
        await _auth.sendPasswordResetEmail(email: email);
        // Poping of the Progress Indicator
        if (context.mounted) {
          Navigator.pop(context);
        }
        // Redirect user to ForgotPasswordHoldPage
        if (context.mounted) {
          PopUpWidgets.diologbox(
            context: context,
            title: "Email Sent",
            content: "Check your email for the password reset link and follow the steps to reset your password.",
          );
        }

        associatedEmail = true;
      }
      // if the entered Email address is not present in "users" collection or Entered email Provider is not "Email & Password" is present in "users" collection
      // that means user entered Email does not have associat account in Firebase realted to "Email & Password" Provider.
      else {
        if (context.mounted) {
          // Poping of the Progress Indicator
          Navigator.of(context).pop();

          PopUpWidgets.diologbox(
            context: context,
            title: "Not found (404)",
            content: "There is no associated account found with entered Email.",
          );
        }
        associatedEmail = false;
      }
    }
    // Handling forgot password auth Exceptions
    on FirebaseAuthException catch (error) {
      if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
        Navigator.pop(context);
        PopUpWidgets.diologbox(
          context: context,
          title: "Network failure",
          content: "Connection failed. Please check your network connection and try again.",
        );
      } else if (error.message == "The supplied auth credential is incorrect, malformed or has expired." && context.mounted) {
        Navigator.pop(context);
        PopUpWidgets.diologbox(
          context: context,
          title: "Invalid email",
          content: "Your entered email is Invalid. Please check your email and try again.",
        );
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          PopUpWidgets.diologbox(
            context: context,
            title: "Network Error",
            content: error.toString(),
          );
        }
      }
    }

    // returning email value
    return associatedEmail;
  }

  // ------------------------------------
  // Method related Firebase Auth SingOut
  // ------------------------------------

  //! Method for SingOut Firebase Provider auth account
  static Future<void> singOut({required BuildContext context}) async {
    try {
      // Remove the entry's of Shared Preferences data.
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('birthYear');
      prefs.remove('name');
      prefs.remove('email');
      prefs.remove('provider');
      prefs.remove('userID');

      // seting isLogin to false.
      await prefs.setBool('isLogin', false);

      // SingOut code for Google SingIn/SingUp
      if (await GoogleSignIn().isSignedIn()) {
        // Sign out the user from google account
        GoogleSignIn().signOut();
      }

      // This method SignOut user from all firebase auth Provider's
      await _auth.signOut();

      // Redirecting user to Welcome Page.
      if (context.mounted) {
        Navigator.of(context).pushNamed(
          RoutesNames.welcomePage,
        );
      }
    }
    //? Handling Error Related Google SignIn/SignUp.
    on FirebaseAuthException catch (error) {
      if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
        Navigator.of(context).pop();
        PopUpWidgets.diologbox(
          context: context,
          title: "Sign up failed",
          content: "Connection failed. Please check your network connection and try again.",
        );
      } else {
        if (context.mounted) {
          Navigator.of(context).pop();
          PopUpWidgets.diologbox(
            context: context,
            title: "Network Error",
            content: error.message.toString(),
          );
        }
      }
    }
  }

  // -----------------------------------------
  // Method Retrive User Authentication Status
  // -----------------------------------------

  //! Method that check user is login or Not with any Provider.
  static Future<bool> isUserLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    return isLogin;
  }
}
