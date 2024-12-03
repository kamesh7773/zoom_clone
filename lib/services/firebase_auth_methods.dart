import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/route_names.dart';
import 'email_auth_backend.dart';
import '../widgets/diolog_box.dart';
import '../utils/internet_checker.dart';
import '../widgets/progress_indicator.dart';

class FirebaseAuthMethods {
  // Variables related to Firebase instances
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // This method genrate personal Meeting ID for user when they signUp for our application.
  // This personal meeting id only genrated for first time when appliation is used by user
  // if user clear the data of application then the application will be genrated au
  static String generate12DigitNumber() {
    Random random = Random();
    String number = '';

    for (int i = 0; i < 12; i++) {
      number += random.nextInt(10).toString(); // Random digit from 0-9
    }

    return number;
  }

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
            "personalMeetingID": generate12DigitNumber(),
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
          await prefs.setString("personalMeetingID", userData["personalMeetingID"]);

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
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

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
            title: "Email not found",
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

  // --------------------------------------
  // Method related Google Auth (OAuth 2.0)
  // --------------------------------------

  //! Method for Google SingIn/SignUp (For Google We don't have two method for signIn/signUp)
  static Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      //? ------------------------
      //? Google Auth code for Web
      //? ------------------------
      // (For runing Google Auth on Web Browser We need add the Web Clint ID (Web Clint ID is avaible on Google Clound Console
      //  Index.html file ex : <meta name="google-signin-client_id" content="152173321595-lb4qla2alg7q3010hrip1p1i1ok997n9.apps.googleusercontent.com.apps.googleusercontent.com"> )
      //  Google Auth Only run on specific "Port 5000" for runing application ex : "flutter run -d edge --web-hostname localhost --web-port 5000"
      if (kIsWeb) {
        //* 1st create a googleProvider instance with the help of the GoogleAuthProvider class constructor.
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        //* 2nd Provider needs some kind of user Google account info for the sign-in process.
        //*     There are multiple providers are there in the google office website you can check them out.
        googleProvider.addScope("email");

        //* 3rd this code pop the google signIn/signUp interface/UI like showing google id that is logged in user's browser
        final UserCredential userCredential = await _auth.signInWithPopup(googleProvider);

        if (context.mounted) {
          ProgressIndicators.showProgressIndicator(context);
        }

        //* 4th storing user info inside the FireStore "users" collection.
        // ? Try & catch block for storing user info at Firestore in "users" collections
        try {
          // creating "users" collection so we can store user specific user data
          await _db.collection("users").doc(_auth.currentUser!.uid).set({
            "name": userCredential.additionalUserInfo!.profile!["name"],
            "email": userCredential.additionalUserInfo!.profile!["email"],
            "imageUrl": userCredential.additionalUserInfo!.profile!["picture"],
            "provider": "Google",
            "userID": _auth.currentUser!.uid,
            "personalMeetingID": generate12DigitNumber(),
          }).then((value) {
            debugPrint("User data saved in Firestore users collection");
          }).catchError((error) {
            debugPrint("User data not saved!");
          });

          // fetching current userId info from "users" collection.
          final currentUserInfo = await _db.collection("users").doc(_auth.currentUser!.uid).get();

          final userData = currentUserInfo.data();

          // creating instace of Shared Preferences.
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("name", userData!["name"]);
          await prefs.setString("email", userData["email"]);
          await prefs.setString("imageUrl", userData["imageUrl"]);
          await prefs.setString("provider", userData["provider"]);
          await prefs.setString("userID", userData["userID"]);
          await prefs.setString("personalMeetingID", userData["personalMeetingID"]);

          //* 6th setting isLogin to "true"
          await prefs.setBool('isLogin', true);
        }

        //? Handling Excetion for Storing user info at FireStore DB.
        on FirebaseAuthException catch (error) {
          if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
            PopUpWidgets.diologbox(
              context: context,
              title: "Network failure",
              content: "Connection failed. Please check your network connection and try again.",
            );
          } else {
            if (context.mounted) {
              PopUpWidgets.diologbox(
                context: context,
                title: "Network Error",
                content: error.toString(),
              );
            }
          }
        }

        //* 7th After succresfully SingIn redirecting user to HomePage
        if (context.mounted) {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesNames.homePage,
            (Route<dynamic> route) => false,
          );
        }

        // if "userCredential.additionalUserInfo!.isNewUser" is "isNewUser" it's mean user account is not presented on our firebase signin
        // console it mean's user is being SingIn/SingUp with Google for fisrt time so we can store the information in fireStore "users" collection.
        // This code used to detected when user login with Google Provider for first time and we can run some kind of logic on in.

        // if (userCredential.additionalUserInfo!.isNewUser) {}
      }
      //? --------------------------------
      //? Google Auth code for Android/IOS
      //? --------------------------------
      else {
        //* 1st this code pop the google signIn/signUp interface/UI like showing google id that is loged in user's devices
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        if (context.mounted) {
          ProgressIndicators.showProgressIndicator(context);
        }

        //! if user Click on the back button while Google OAUth Popup is showing or he dismis the Google OAuth Pop By clicking anywhere on the screen then this under code\
        //! will pop-out the Progress Indicator.
        if (googleUser == null && context.mounted) {
          Navigator.of(context).pop();
        }

        //! if User Does Nothngs and continues to Google O Auth Sign In then this under code will executed.
        else {
          //* 2nd When user clicks on the Pop Google Account then this code retirve the GoogleSignInTokenData (accesToken/IdToken)
          final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

          // if accessToken or idToken null the return nothing. ( accessToken get null when user dismis the Google account Pop Menu)
          if (googleAuth?.accessToken == null && googleAuth?.idToken == null) {
            return;
          }
          // if accessToken and idToken is not null only then we process to login
          else {
            //* 3rd In upper code (2nd code ) we are ritrieving the "GoogleSignInTokenData" Instance (googleAuth) now with the help googleAuth instance we gonna
            //* retrive the "accessToken" and idToken
            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth?.accessToken,
              idToken: googleAuth?.idToken,
            );

            //* 4th This code help user to singIn/SingUp the user with Google Account.
            // when user click on the Popup google id's then this code will return all the User google account information
            // (Info like : Google account user name, user IMG, user email is verfied etc)
            UserCredential userCredential = await _auth.signInWithCredential(credential);

            //* 5th stroing user info inside the FireStore "users" collection.
            // ? Try & catch block for storing user info at Firestore in "users" collections
            try {
              // Checking weather user is already SignUp or not
              var signUpStatus = await FirebaseAuthMethods.isSignUpforFirstTime();

              // if user is contining with Google Sign up then only we create personalMeetingID (Sign UP Condiation)
              if (signUpStatus.signUpWithGoogle) {
                // creating "users" collection so we can store user specific user data
                await _db.collection("users").doc(_auth.currentUser!.uid).set({
                  "name": userCredential.additionalUserInfo!.profile!["name"],
                  "email": userCredential.additionalUserInfo!.profile!["email"],
                  "imageUrl": userCredential.additionalUserInfo!.profile!["picture"],
                  "provider": "Google",
                  "userID": _auth.currentUser!.uid,
                  "personalMeetingID": generate12DigitNumber(),
                }).then((value) {
                  debugPrint("User data saved in Firestore users collection");
                }).catchError((error) {
                  debugPrint("User data not saved!");
                });

                // fetching current userId info from "users" collection.
                final currentUserInfo = await _db.collection("users").doc(_auth.currentUser!.uid).get();

                final userData = currentUserInfo.data();

                // creating instace of Shared Preferences.
                final SharedPreferences prefs = await SharedPreferences.getInstance();

                //* 6th writing current User info data to SharedPreferences.
                await prefs.setString("name", userData!["name"]);
                await prefs.setString("email", userData["email"]);
                await prefs.setString("imageUrl", userData["imageUrl"]);
                await prefs.setString("provider", userData["provider"]);
                await prefs.setString("userID", userData["userID"]);
                await prefs.setString("personalMeetingID", userData["personalMeetingID"]);

                //* 7th setting isLogin to "true"
                await prefs.setBool('isLogin', true);

                //* 8th After succresfully SignIn/SignUp we set the isSignUpforFirstTime shared prefernce value to true.
                await prefs.setBool('signUpWithGoogle', false);

                //* 9th After succresfully SignIn/SignUp redirecting user to HomePage
                if (context.mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    RoutesNames.homePage,
                    (Route<dynamic> route) => false,
                  );
                }
              }
              // if user is sign in Google then we will not create personalMeetingID (Sign In Condition)
              else {
                // fetching current userId info from "users" collection.
                final currentUserInfo = await _db.collection("users").doc(_auth.currentUser!.uid).get();

                final userData = currentUserInfo.data();

                // creating "users" collection so we can store user specific user data
                await _db.collection("users").doc(_auth.currentUser!.uid).set({
                  "name": userCredential.additionalUserInfo!.profile!["name"],
                  "email": userCredential.additionalUserInfo!.profile!["email"],
                  "imageUrl": userCredential.additionalUserInfo!.profile!["picture"],
                  "provider": "Google",
                  "userID": _auth.currentUser!.uid,
                  "personalMeetingID": userData!["personalMeetingID"],
                }).then((value) {
                  debugPrint("User data saved in Firestore users collection");
                }).catchError((error) {
                  debugPrint("User data not saved!");
                });

                // creating instace of Shared Preferences.
                final SharedPreferences prefs = await SharedPreferences.getInstance();

                //* 6th writing current User info data to SharedPreferences.
                await prefs.setString("name", userData["name"]);
                await prefs.setString("email", userData["email"]);
                await prefs.setString("imageUrl", userData["imageUrl"]);
                await prefs.setString("provider", userData["provider"]);
                await prefs.setString("userID", userData["userID"]);
                await prefs.setString("personalMeetingID", userData["personalMeetingID"]);

                //* 7th setting isLogin to "true"
                await prefs.setBool('isLogin', true);

                //* 9th After succresfully SignIn/SignUp redirecting user to HomePage
                if (context.mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    RoutesNames.homePage,
                    (Route<dynamic> route) => false,
                  );
                }
              }
            }

            //? Handling Excetion for Storing user info at FireStore DB.
            on FirebaseAuthException catch (error) {
              if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
                PopUpWidgets.diologbox(
                  context: context,
                  title: "Network failure",
                  content: "Connection failed. Please check your network connection and try again.",
                );
              } else {
                if (context.mounted) {
                  PopUpWidgets.diologbox(
                    context: context,
                    title: "Network Error",
                    content: error.toString(),
                  );
                }
              }
            }

            //? if "userCredential.additionalUserInfo!.isNewUser" is "isNewUser" it's mean user account is not presented on our firebase signin
            //? console it mean's user is being SingIn/SingUp with Google for fisrt time so we can store the information in fireStore "users" collection.
            //? This code used to detected when user login with Google Provider for first time and we can run some kind of logic on in.

            // if (userCredential.additionalUserInfo!.isNewUser) {}
          }
        }
      }
    }
    //? Handling Error Related Google SignIn/SignUp.
    on FirebaseAuthException catch (error) {
      if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
        Navigator.pop(context);
        PopUpWidgets.diologbox(
          context: context,
          title: "Network failure",
          content: "Connection failed. Please check your network connection and try again.",
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

  // ----------------------------
  // Method related FaceBook Auth
  // ----------------------------

  //! Method for Facebook SingIn/SignUp
  static Future<void> signInwithFacebook({required BuildContext context}) async {
    try {
      // Showing Progress Indicator.
      if (context.mounted) {
        ProgressIndicators.showProgressIndicator(context);
      }

      //* 1st this code pop the Facebook signIn/signUp page in browser On Android
      //* and if we are web app then open Pop-Up Facebook signIn/signUp interface/UI In web browser
      final LoginResult loginResult = await FacebookAuth.instance.login();

      //! if user Click on the back button while FackBook AUth Browser Popup is showing or he dismis the FaceBook Auth Browser PopUp By clicking anywhere on the screen then this under code
      //! will pop-out the Progress Indicator.
      if (loginResult.accessToken == null && context.mounted) {
        Navigator.of(context).pop();
      }

      //! if User Does Nothngs and continues to Facebook Auth browser Sign In then this under code will executed.
      else {
        //* 2nd When user get login after entering their login password then this code retirve the FacebookTokenData.
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

        // if accessToken or idToken null the return nothing.
        if (loginResult.accessToken == null) {
          return;
        }
        // if accessToken and idToken is not null only then we process to login
        else {
          //* 3rd this method singIn the user with credetial
          final UserCredential userCredentail = await _auth.signInWithCredential(facebookAuthCredential);

          //* 4th stroing user info inside the FireStore "users" collection.
          // ? Try & catch block for storing user info at Firestore in "users" collections
          try {
            // Checking weather user is already SignUp or not
            var signUpStatus = await FirebaseAuthMethods.isSignUpforFirstTime();

            // if user is contining with Faceboook Sign then only we create personalMeetingID (Sign UP Condiation)
            if (signUpStatus.signUpWithFacebook) {
              // creating "users" collection so we can store user specific user data
              await _db.collection("users").doc(_auth.currentUser!.uid).set({
                "name": userCredentail.additionalUserInfo!.profile!["name"],
                "email": userCredentail.additionalUserInfo!.profile!["email"],
                "imageUrl": userCredentail.additionalUserInfo!.profile!["picture"]["data"]["url"],
                "provider": "Facebook",
                "userID": _auth.currentUser!.uid,
                "personalMeetingID": generate12DigitNumber(),
              }).then((value) {
                debugPrint("User data saved in Firestore users collection");
              }).catchError((error) {
                debugPrint("User data not saved!");
              });

              // fetching current userId info from "users" collection.
              final currentUserInfo = await _db.collection("users").doc(_auth.currentUser!.uid).get();

              final userData = currentUserInfo.data();

              // creating instace of Shared Preferences.
              final SharedPreferences prefs = await SharedPreferences.getInstance();

              //* 5th writing current User info data to SharedPreferences.
              await prefs.setString("name", userData!["name"]);
              await prefs.setString("email", userData["email"]);
              await prefs.setString("imageUrl", userData["imageUrl"]);
              await prefs.setString("provider", userData["provider"]);
              await prefs.setString("userID", userData["userID"]);
              await prefs.setString("personalMeetingID", userData["personalMeetingID"]);

              //* 6th setting isLogin to "true"
              await prefs.setBool('isLogin', true);

              //* 7th After succresfully SignIn/SignUp we set the isSignUpforFirstTime shared prefernce value to true.
              await prefs.setBool('signUpWithFacebook', false);

              //* 8th After succresfully SingIn redirecting user to HomePage
              if (context.mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RoutesNames.homePage,
                  (Route<dynamic> route) => false,
                );
              }
            }
            // if user is sign in Google then we will not create personalMeetingID (Sign In Condition)
            else {
              // fetching current userId info from "users" collection.
              final currentUserInfo = await _db.collection("users").doc(_auth.currentUser!.uid).get();

              final userData = currentUserInfo.data();

              // creating "users" collection so we can store user specific user data
              await _db.collection("users").doc(_auth.currentUser!.uid).set({
                "name": userCredentail.additionalUserInfo!.profile!["name"],
                "email": userCredentail.additionalUserInfo!.profile!["email"],
                "imageUrl": userCredentail.additionalUserInfo!.profile!["picture"]["data"]["url"],
                "provider": "Facebook",
                "userID": _auth.currentUser!.uid,
                "personalMeetingID": userData!["personalMeetingID"],
              }).then((value) {
                debugPrint("User data saved in Firestore users collection");
              }).catchError((error) {
                debugPrint("User data not saved!");
              });

              // creating instace of Shared Preferences.
              final SharedPreferences prefs = await SharedPreferences.getInstance();

              //* 6th writing current User info data to SharedPreferences.
              await prefs.setString("name", userData["name"]);
              await prefs.setString("email", userData["email"]);
              await prefs.setString("imageUrl", userData["imageUrl"]);
              await prefs.setString("provider", userData["provider"]);
              await prefs.setString("userID", userData["userID"]);
              await prefs.setString("personalMeetingID", userData["personalMeetingID"]);

              //* 7th setting isLogin to "true"
              await prefs.setBool('isLogin', true);

              //* 8th After succresfully SignIn/SignUp redirecting user to HomePage
              if (context.mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RoutesNames.homePage,
                  (Route<dynamic> route) => false,
                );
              }
            }
          }

          //? Handling Excetion for Storing user info at FireStore DB.
          on FirebaseAuthException catch (error) {
            if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
              PopUpWidgets.diologbox(
                context: context,
                title: "Network failure",
                content: "Connection failed. Please check your network connection and try again.",
              );
            } else {
              if (context.mounted) {
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

    //? Handling Error Related Facebook SignIn/SignUp.
    on FirebaseAuthException catch (error) {
      if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
        PopUpWidgets.diologbox(
          context: context,
          title: "Network failure",
          content: "Connection failed. Please check your network connection and try again.",
        );
      } else if (error.message == "[firebase_auth/account-exists-with-different-credential] An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address." && context.mounted) {
        PopUpWidgets.diologbox(
          context: context,
          title: "Email already used",
          content: "The email address is already in use by another account.",
        );
      } else {
        if (context.mounted) {
          PopUpWidgets.diologbox(
            context: context,
            title: "Network Error",
            content: error.toString(),
          );
        }
      }
    }
  }

  // ---------------------------
  // Method related Twitter Auth
  // ---------------------------

  //! Method for Twitter SingIn/SignUp
  static Future<void> singInwithTwitter({required BuildContext context}) async {
    try {
      //? --------------------------
      //? Twitter Auth code for Web
      //? --------------------------
      if (kIsWeb) {
        //* 1st creating twitterProvider instance with help of TwitterAuthProvider class construtor
        TwitterAuthProvider twitterProvider = TwitterAuthProvider();

        //* 2nd this code pop the Twitter signIn/signUp interface/UI in user's browser
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(twitterProvider);

        if (context.mounted) {
          ProgressIndicators.showProgressIndicator(context);
        }

        //* 3rd stroing user info inside the FireStore "users" collection.
        // ? Try & catch block for storing user info at Firestore in "users" collections
        try {
          // creating "users" collection so we can store user specific user data
          await _db.collection("users").doc(_auth.currentUser!.uid).set({
            "name": userCredential.additionalUserInfo!.profile!["name"],
            "email": userCredential.additionalUserInfo!.profile!["email"],
            "imageUrl": userCredential.additionalUserInfo!.profile!["profile_image_url_https"],
            "provider": "Twitter",
            "userID": _auth.currentUser!.uid,
            "personalMeetingID": generate12DigitNumber(),
          }).then((value) {
            debugPrint("User data saved in Firestore users collection");
          }).catchError((error) {
            debugPrint("User data not saved!");
          });

          // fetching current userId info from "users" collection.
          final currentUserInfo = await _db.collection("users").doc(_auth.currentUser!.uid).get();

          final userData = currentUserInfo.data();

          // creating instace of Shared Preferences.
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          //* 4th writing current User info data to SharedPreferences.
          await prefs.setString("name", userData!["name"]);
          await prefs.setString("email", userData["email"]);
          await prefs.setString("imageUrl", userData["imageUrl"]);
          await prefs.setString("provider", userData["provider"]);
          await prefs.setString("userID", userData["userID"]);
          await prefs.setString("personalMeetingID", userData["personalMeetingID"]);

          //* 5th setting isLogin to "true"
          await prefs.setBool('isLogin', true);
        }

        //? Handling Excetion for Storing user info at FireStore DB.
        on FirebaseAuthException catch (error) {
          if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
            PopUpWidgets.diologbox(
              context: context,
              title: "Network failure",
              content: "Connection failed. Please check your network connection and try again.",
            );
          } else {
            if (context.mounted) {
              PopUpWidgets.diologbox(
                context: context,
                title: "Network Error",
                content: error.message.toString(),
              );
            }
          }
        }

        //* 6th After succresfully SingIn redirecting user to HomePage
        if (context.mounted) {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesNames.homePage,
            (Route<dynamic> route) => false,
          );
        }
      }
      //? ---------------------------------
      //? Twitter Auth code for Android/IOS
      //? ---------------------------------
      else {
        //* 1st creating twitterProvider instance with help of TwitterAuthProvider class construtor
        TwitterAuthProvider twitterProvider = TwitterAuthProvider();

        // Showing Progress Indicator.
        if (context.mounted) {
          ProgressIndicators.showProgressIndicator(context);
        }

        //* 2nd this code pop the Twitter signIn/signUp interface/UI in user's browser
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithProvider(twitterProvider);

        //! if user Click on the back button while Twitter OAUth Popup is showing or he dismis the Twitter OAuth Pop By clicking anywhere on the screen then this under code
        //! will pop-out the Progress Indicator.
        if (userCredential.additionalUserInfo == null && context.mounted) {
          Navigator.of(context).pop();
        }

        //! if User Does Nothngs and continues to Twitter O Auth Sign In then this under code will executed.
        else {
          //* 3rd stroing user info inside the FireStore "users" collection.
          // ? Try & catch block for storing user info at Firestore in "users" collections
          try {
            // Checking weather user is already SignUp or not
            var signUpStatus = await FirebaseAuthMethods.isSignUpforFirstTime();

            if (signUpStatus.signUpWithTwitter) {
              // creating "users" collection so we can store user specific user data
              await _db.collection("users").doc(_auth.currentUser!.uid).set({
                "name": userCredential.additionalUserInfo!.profile!["name"],
                "email": userCredential.additionalUserInfo!.profile!["email"],
                "imageUrl": userCredential.additionalUserInfo!.profile!["profile_image_url_https"],
                "provider": "Twitter",
                "userID": _auth.currentUser!.uid,
                "personalMeetingID": generate12DigitNumber(),
              }).then((value) {
                debugPrint("User data saved in Firestore users collection");
              }).catchError((error) {
                debugPrint("User data not saved!");
              });

              // fetching current userId info from "users" collection.
              final currentUserInfo = await _db.collection("users").doc(_auth.currentUser!.uid).get();

              final userData = currentUserInfo.data();

              // creating instace of Shared Preferences.
              final SharedPreferences prefs = await SharedPreferences.getInstance();

              //* 4th writing current User info data to SharedPreferences.
              await prefs.setString("name", userData!["name"]);
              await prefs.setString("email", userData["email"]);
              await prefs.setString("imageUrl", userData["imageUrl"]);
              await prefs.setString("provider", userData["provider"]);
              await prefs.setString("userID", userData["userID"]);
              await prefs.setString("personalMeetingID", userData["personalMeetingID"]);

              //* 5th setting isLogin to "true"
              await prefs.setBool('isLogin', true);

              //* 6th After succresfully SignIn/SignUp we set the isSignUpforFirstTime shared prefernce value to true.
              await prefs.setBool('signUpWithTwitter', false);

              //* 7th After succresfully SingIn redirecting user to HomePage
              if (context.mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RoutesNames.homePage,
                  (Route<dynamic> route) => false,
                );
              }
            }
            // if user is sign in Google then we will not create personalMeetingID (Sign In Condition)
            else {
              // fetching current userId info from "users" collection.
              final currentUserInfo = await _db.collection("users").doc(_auth.currentUser!.uid).get();

              final userData = currentUserInfo.data();

              // creating "users" collection so we can store user specific user data
              await _db.collection("users").doc(_auth.currentUser!.uid).set({
                "name": userCredential.additionalUserInfo!.profile!["name"],
                "email": userCredential.additionalUserInfo!.profile!["email"],
                "imageUrl": userCredential.additionalUserInfo!.profile!["profile_image_url_https"],
                "provider": "Twitter",
                "userID": _auth.currentUser!.uid,
                "personalMeetingID": userData!["personalMeetingID"],
              }).then((value) {
                debugPrint("User data saved in Firestore users collection");
              }).catchError((error) {
                debugPrint("User data not saved!");
              });

              // creating instace of Shared Preferences.
              final SharedPreferences prefs = await SharedPreferences.getInstance();

              //* 4th writing current User info data to SharedPreferences.
              await prefs.setString("name", userData["name"]);
              await prefs.setString("email", userData["email"]);
              await prefs.setString("imageUrl", userData["imageUrl"]);
              await prefs.setString("provider", userData["provider"]);
              await prefs.setString("userID", userData["userID"]);
              await prefs.setString("personalMeetingID", userData["personalMeetingID"]);

              //* 5th setting isLogin to "true"
              await prefs.setBool('isLogin', true);

              //* 6th After succresfully SingIn redirecting user to HomePage
              if (context.mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RoutesNames.homePage,
                  (Route<dynamic> route) => false,
                );
              }
            }
          }

          //? Handling Excetion for Storing user info at FireStore DB.
          on FirebaseAuthException catch (error) {
            if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
              PopUpWidgets.diologbox(
                context: context,
                title: "Network failure",
                content: "Connection failed. Please check your network connection and try again.",
              );
            } else {
              if (context.mounted) {
                PopUpWidgets.diologbox(
                  context: context,
                  title: error.code,
                  content: error.message.toString(),
                );
              }
            }
          }
        }
      }
    }
    //? Handling Error Related Google SignIn/SignUp.
    on FirebaseAuthException catch (error) {
      if (error.message == "A network error (such as timeout, interrupted connection or unreachable host) has occurred." && context.mounted) {
        Navigator.of(context).pop();
        PopUpWidgets.diologbox(
          context: context,
          title: "Network failure",
          content: "Connection failed. Please check your network connection and try again.",
        );
      }
      if (error.message == "An internal error has occurred." && context.mounted) {
        Navigator.of(context).pop();
        PopUpWidgets.diologbox(
          context: context,
          title: "Network failure",
          content: "Connection failed. Please check your network connection and try again.",
        );
      } else {
        if (context.mounted) {
          Navigator.of(context).pop();
          PopUpWidgets.diologbox(
            context: context,
            title: error.code,
            content: error.message.toString(),
          );
        }
      }
    }
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
      prefs.remove('imageUrl');
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

  // -----------------------------------------------
  // Methods for checking app is open for first time
  // -----------------------------------------------

  //! Here we retrieve the details whether the application is opened for the first time or not.
  static Future<({bool signUpWithGoogle, bool signUpWithFacebook, bool signUpWithTwitter})> isSignUpforFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve values from SharedPreferences
    bool signUpWithGoogle = prefs.getBool('signUpWithGoogle') ?? true;
    bool signUpWithFacebook = prefs.getBool('signUpWithFacebook') ?? true;
    bool signUpWithTwitter = prefs.getBool('signUpWithTwitter') ?? true;

    // Return a record with the retrieved values
    return (signUpWithGoogle: signUpWithGoogle, signUpWithFacebook: signUpWithFacebook, signUpWithTwitter: signUpWithTwitter);
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
