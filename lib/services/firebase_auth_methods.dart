import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/route_names.dart';
import '../utils/internet_checker.dart';
import '../widgets/diolog_box.dart';
import '../widgets/progress_indicator.dart';
import 'email_auth_backend.dart';

class FirebaseAuthMethods {
  // Variables related to Firebase instances
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // This method generates a personal meeting ID for the user when they sign up for the application.
  // This personal meeting ID is generated only the first time the application is used by the user.
  // If the user clears the application data, a new ID will be generated.
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

  //! Email & Password Sign-Up Method
  static Future<void> signUpWithEmail({
    required String birthYear,
    required String email,
    required String fname,
    required String lname,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Show progress indicator
      ProgressIndicators.showProgressIndicator(context);

      // Check if the email exists with the "Email & Password" provider in the users collection
      QuerySnapshot queryForEmailAndProvider = await _db
          .collection('users')
          .where("email", isEqualTo: email)
          .where("provider", isEqualTo: "Email & Password")
          .get();

      // If the email already exists with the Email & Password provider
      if (queryForEmailAndProvider.docs.isNotEmpty && context.mounted) {
        Navigator.of(context).pop();
        PopUpWidgets.diologbox(
          context: context,
          title: "Email already used",
          content: "The email address is already in use by another account.",
        );
      }
      // If the email doesn't exist or uses a different provider
      else {
        if (context.mounted) {
          try {
            // Send OTP to the user's email address
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
                content:
                    "Connection failed. Please check your network connection and try again.",
              );
            }
            // If internet is available, redirect to the OTP page
            else if (!isInternet && context.mounted) {
              Navigator.of(context).pushNamed(
                RoutesNames.otpVerification,
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
          //? Handling email OTP errors
          catch (error) {
            if (error ==
                "ClientException with SocketException: Failed host lookup: 'definite-emilee-kamesh-564a9766.koyeb.app' (OS Error: No address associated with hostname, errno = 7), uri=https://definite-emilee-kamesh-564a9766.koyeb.app/api/send-otp") {
              if (context.mounted) {
                // Popping out the progress indicator
                Navigator.of(context).pop();

                PopUpWidgets.diologbox(
                  context: context,
                  title: "Network failure",
                  content:
                      "Connection failed. Please check your network connection and try again.",
                );
              }
            } else {
              if (context.mounted) {
                // Popping out the progress indicator
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
    // Handle Firebase Firestore exceptions
    on FirebaseException catch (error) {
      if (error.message ==
              "A network error (such as timeout, interrupted connection or unreachable host) has occurred." &&
          context.mounted) {
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
    // Try and catch block for Email OTP Auth API
    try {
      ProgressIndicators.showProgressIndicator(context);

      // Verify the email OTP
      var res = await EmailOtpAuth.verifyOtp(otp: emailOTP);

      // If OTP verification is successful, create user account and store data
      if (res["message"] == "OTP Verified") {
        // Try and catch block for Firebase Email Sign-Up Auth
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
            "imageUrl":
                "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=",
            "provider": "Email & Password",
            "userID": _auth.currentUser!.uid,
            "personalMeetingID": generate12DigitNumber(),
          });

          // Fetch current user info from Firestore
          final currentUserInfo = await _db
              .collection("users")
              .doc(_auth.currentUser!.uid)
              .get();
          final userData = currentUserInfo.data();

          // Store user data in SharedPreferences
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("birthYear", userData!["birthYear"]);
          await prefs.setString("name", userData["name"]);
          await prefs.setString("email", userData["email"]);
          await prefs.setString("imageUrl", userData["imageUrl"]);
          await prefs.setString("provider", userData["provider"]);
          await prefs.setString("userID", userData["userID"]);
          await prefs.setString(
              "personalMeetingID", userData["personalMeetingID"]);

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
          if (error.message ==
                  "A network error (such as timeout, interrupted connection or unreachable host) has occurred." &&
              context.mounted) {
            Navigator.of(context).pop();
            PopUpWidgets.diologbox(
              context: context,
              title: "Sign up failed",
              content:
                  "Connection failed. Please check your network connection and try again.",
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
          content:
              "It seems like the OTP is incorrect. Please try again or resend the OTP.",
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
      if (error ==
          "ClientException with SocketException: Failed host lookup: 'definite-emilee-kamesh-564a9766.koyeb.app' (OS Error: No address associated with hostname, errno = 7), uri=https://definite-emilee-kamesh-564a9766.koyeb.app/api/verify-otp") {
        if (context.mounted) {
          Navigator.pop(context);
          PopUpWidgets.diologbox(
            context: context,
            title: "Sign up failed",
            content:
                "Connection failed. Please check your network connection and try again.",
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

  //! Resend OTP to Email Method
  static Future<void> resentEmailOTP(
      {required email, required BuildContext context}) async {
    try {
      // Show the progress indicator
      ProgressIndicators.showProgressIndicator(context);
      await EmailOtpAuth.sendOTP(email: email);
      // Pop the progress indicator
      if (context.mounted) {
        Navigator.pop(context);

        PopUpWidgets.diologbox(
          context: context,
          title: "OTP sent",
          content:
              "Your OTP has been successfully sent to your registered email address. Please check your inbox.",
        );
      }
    }
    //? Handling email OTP errors
    catch (error) {
      if (error ==
          "ClientException with SocketException: Failed host lookup: 'definite-emilee-kamesh-564a9766.koyeb.app' (OS Error: No address associated with hostname, errno = 7), uri=https://definite-emilee-kamesh-564a9766.koyeb.app/api/send-otp") {
        if (context.mounted) {
          // Pop the progress indicator
          Navigator.of(context).pop();

          PopUpWidgets.diologbox(
            context: context,
            title: "Network failure",
            content:
                "Connection failed. Please check your network connection and try again.",
          );
        }
      } else {
        if (context.mounted) {
          // Pop the progress indicator
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
      // Show CircularProgressIndicator
      ProgressIndicators.showProgressIndicator(context);

      // Method for signing in the user with email & password
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch current userId info from the "users" collection
      final currentUserInfo =
          await _db.collection("users").doc(_auth.currentUser!.uid).get();

      final userData = currentUserInfo.data();

      // Create an instance of Shared Preferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Write current user info data to SharedPreferences
      await prefs.setString("birthYear", userData!["birthYear"]);
      await prefs.setString("name", userData["name"]);
      await prefs.setString("email", userData["email"]);
      await prefs.setString("provider", userData["provider"]);
      await prefs.setString("userID", userData["userID"]);

      // Set isLogin to "true"
      await prefs.setBool('isLogin', true);

      // After successful login, redirect the user to the HomePage
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.of(context).pushNamedAndRemoveUntil(
          RoutesNames.homePage,
          (Route<dynamic> route) => false,
        );
      }
    }
    // Handle login auth exceptions
    on FirebaseAuthException catch (error) {
      if (error.message ==
              "A network error (such as timeout, interrupted connection or unreachable host) has occurred." &&
          context.mounted) {
        Navigator.pop(context);
        PopUpWidgets.diologbox(
          context: context,
          title: "Sign up failed",
          content:
              "Connection failed. Please check your network connection and try again.",
        );
      } else if (error.message ==
              "The supplied auth credential is incorrect, malformed or has expired." &&
          context.mounted) {
        Navigator.pop(context);
        PopUpWidgets.diologbox(
          context: context,
          title: "Invalid credentials",
          content:
              "Your entered email and password are invalid. Please check your email & password and try again.",
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

  //! Email & Password Forgot Password/Reset Method
  static Future<bool> forgotEmailPassword({
    required String email,
    required BuildContext context,
  }) async {
    // Variable declaration
    late bool associatedEmail;
    try {
      // Show Progress Indicator
      ProgressIndicators.showProgressIndicator(context);
      //* First, we check if the entered email address is already present & its provider is "Email & Password" in the "users" collection by querying Firestore's "users" Collection.
      // Search for Email Address & "Email & Password" provider in the "users" collection at once
      QuerySnapshot queryForEmailAndProvider = await _db
          .collection('users')
          .where("email", isEqualTo: email)
          .where("provider", isEqualTo: "Email & Password")
          .get();

      // If the entered Email address is already present in the "users" collection and the Provider is "Email & Password"
      // it means that the user has entered the correct email address, and we can send the Forgot password link to the user's Email Address.
      if (queryForEmailAndProvider.docs.isNotEmpty && context.mounted) {
        // Method for sending forgot password link to the user
        await _auth.sendPasswordResetEmail(email: email);
        // Pop the Progress Indicator
        if (context.mounted) {
          Navigator.pop(context);
        }
        // Redirect user to ForgotPasswordHoldPage
        if (context.mounted) {
          PopUpWidgets.diologbox(
            context: context,
            title: "Email Sent",
            content:
                "Check your email for the password reset link and follow the steps to reset your password.",
          );
        }

        associatedEmail = true;
      }
      // If the entered Email address is not present in the "users" collection or the entered email Provider is not "Email & Password" in the "users" collection
      // that means the user entered an Email that does not have an associated account in Firebase related to the "Email & Password" Provider.
      else {
        if (context.mounted) {
          // Pop the Progress Indicator
          Navigator.of(context).pop();

          PopUpWidgets.diologbox(
            context: context,
            title: "Email not found",
            content: "There is no associated account found with the entered Email.",
          );
        }
        associatedEmail = false;
      }
    }
    // Handle forgot password auth exceptions
    on FirebaseAuthException catch (error) {
      if (error.message ==
              "A network error (such as timeout, interrupted connection or unreachable host) has occurred." &&
          context.mounted) {
        Navigator.pop(context);
        PopUpWidgets.diologbox(
          context: context,
          title: "Network failure",
          content:
              "Connection failed. Please check your network connection and try again.",
        );
      } else if (error.message ==
              "The supplied auth credential is incorrect, malformed or has expired." &&
          context.mounted) {
        Navigator.pop(context);
        PopUpWidgets.diologbox(
          context: context,
          title: "Invalid email",
          content:
              "Your entered email is invalid. Please check your email and try again.",
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

    // Return email value
    return associatedEmail;
  }

  // --------------------------------------
  // Methods related to Google Auth (OAuth 2.0)
  // --------------------------------------

  //! Method for Google Sign-In/Sign-Up (For Google, we don't have separate methods for signIn/signUp)
  static Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      //? ------------------------
      //? Google Auth code for Web
      //? ------------------------
      // (For running Google Auth on a Web Browser, we need to add the Web Client ID (Web Client ID is available on Google Cloud Console
      //  Index.html file example: <meta name="google-signin-client_id" content="152173321595-lb4qla2alg7q3010hrip1p1i1ok997n9.apps.googleusercontent.com.apps.googleusercontent.com"> )
      //  Google Auth only runs on specific "Port 5000" for running the application example: "flutter run -d edge --web-hostname localhost --web-port 5000"
      if (kIsWeb) {
        //* First, create a googleProvider instance with the help of the GoogleAuthProvider class constructor.
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        //* Second, the provider needs some kind of user Google account info for the sign-in process.
        //*     There are multiple providers available on the Google official website you can check them out.
        googleProvider.addScope("email");

        //* Third, this code pops the Google signIn/signUp interface/UI like showing Google ID that is logged in user's browser
        final UserCredential userCredential =
            await _auth.signInWithPopup(googleProvider);

        if (context.mounted) {
          ProgressIndicators.showProgressIndicator(context);
        }

        //* Fourth, store user info inside the Firestore "users" collection.
        // ? Try & catch block for storing user info at Firestore in "users" collections
        try {
          // Create "users" collection so we can store user-specific user data
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

          // Fetch current userId info from "users" collection
          final currentUserInfo = await _db
              .collection("users")
              .doc(_auth.currentUser!.uid)
              .get();

          final userData = currentUserInfo.data();

          // Create an instance of Shared Preferences
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("name", userData!["name"]);
          await prefs.setString("email", userData["email"]);
          await prefs.setString("imageUrl", userData["imageUrl"]);
          await prefs.setString("provider", userData["provider"]);
          await prefs.setString("userID", userData["userID"]);
          await prefs.setString(
              "personalMeetingID", userData["personalMeetingID"]);

          //* Sixth, set isLogin to "true"
          await prefs.setBool('isLogin', true);
        }

        //? Handle exceptions for storing user info at Firestore DB
        on FirebaseAuthException catch (error) {
          if (error.message ==
                  "A network error (such as timeout, interrupted connection or unreachable host) has occurred." &&
              context.mounted) {
            PopUpWidgets.diologbox(
              context: context,
              title: "Network failure",
              content:
                  "Connection failed. Please check your network connection and try again.",
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

        //* Seventh, after successfully signing in, redirect the user to the HomePage
        if (context.mounted) {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesNames.homePage,
            (Route<dynamic> route) => false,
          );
        }

        // If "userCredential.additionalUserInfo!.isNewUser" is "isNewUser" it means the user account is not present on our Firebase sign-in
        // console it means the user is being signed in/signed up with Google for the first time so we can store the information in Firestore "users" collection.
        // This code is used to detect when a user logs in with Google Provider for the first time and we can run some kind of logic on it.

        // if (userCredential.additionalUserInfo!.isNewUser) {}
      }
      //? --------------------------------
      //? Google Auth code for Android/IOS
      //? --------------------------------
      else {
        //* First, this code pops the Google signIn/signUp interface/UI like showing Google ID that is logged in user's devices
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        if (context.mounted) {
          ProgressIndicators.showProgressIndicator(context);
        }

        //! If the user clicks on the back button while the Google OAuth Popup is showing or dismisses the Google OAuth Pop by clicking anywhere on the screen then this code
        //! will pop out the Progress Indicator.
        if (googleUser == null && context.mounted) {
          Navigator.of(context).pop();
        }

        //! If the user does nothing and continues to Google OAuth Sign In then this code will be executed.
        else {
          //* Second, when the user clicks on the Pop Google Account then this code retrieves the GoogleSignInTokenData (accessToken/IdToken)
          final GoogleSignInAuthentication? googleAuth =
              await googleUser?.authentication;

          // If accessToken or idToken is null then return nothing. (accessToken gets null when the user dismisses the Google account Pop Menu)
          if (googleAuth?.accessToken == null && googleAuth?.idToken == null) {
            return;
          }
          // If accessToken and idToken are not null only then we process to login
          else {
            //* Third, in the upper code (second code) we are retrieving the "GoogleSignInTokenData" Instance (googleAuth) now with the help of googleAuth instance we gonna
            //* retrieve the "accessToken" and idToken
            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth?.accessToken,
              idToken: googleAuth?.idToken,
            );

            //* Fourth, this code helps the user to sign in/sign up with a Google Account.
            // When the user clicks on the Popup Google ID's then this code will return all the User Google account information
            // (Info like: Google account user name, user IMG, user email is verified, etc.)
            UserCredential userCredential =
                await _auth.signInWithCredential(credential);

            //* Fifth, store user info inside the Firestore "users" collection.
            // ? Try & catch block for storing user info at Firestore in "users" collections
            try {
              // Check whether the user is already signed up or not
              var signUpStatus =
                  await FirebaseAuthMethods.isSignUpforFirstTime();

              // If the user is continuing with Google Sign up then only we create personalMeetingID (Sign UP Condition)
              if (signUpStatus.signUpWithGoogle) {
                // Create "users" collection so we can store user-specific user data
                await _db.collection("users").doc(_auth.currentUser!.uid).set({
                  "name": userCredential.additionalUserInfo!.profile!["name"],
                  "email":
                      userCredential.additionalUserInfo!.profile!["email"],
                  "imageUrl":
                      userCredential.additionalUserInfo!.profile!["picture"],
                  "provider": "Google",
                  "userID": _auth.currentUser!.uid,
                  "personalMeetingID": generate12DigitNumber(),
                }).then((value) {
                  debugPrint("User data saved in Firestore users collection");
                }).catchError((error) {
                  debugPrint("User data not saved!");
                });

                // Fetch current userId info from "users" collection
                final currentUserInfo = await _db
                    .collection("users")
                    .doc(_auth.currentUser!.uid)
                    .get();

                final userData = currentUserInfo.data();

                // Create an instance of Shared Preferences
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                //* Sixth, write current User info data to SharedPreferences
                await prefs.setString("name", userData!["name"]);
                await prefs.setString("email", userData["email"]);
                await prefs.setString("imageUrl", userData["imageUrl"]);
                await prefs.setString("provider", userData["provider"]);
                await prefs.setString("userID", userData["userID"]);
                await prefs.setString(
                    "personalMeetingID", userData["personalMeetingID"]);

                //* Seventh, set isLogin to "true"
                await prefs.setBool('isLogin', true);

                //* Eighth, after successfully signing in/signing up we set the isSignUpforFirstTime shared preference value to true.
                await prefs.setBool('signUpWithGoogle', false);

                //* Ninth, after successfully signing in/signing up redirect the user to the HomePage
                if (context.mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    RoutesNames.homePage,
                    (Route<dynamic> route) => false,
                  );
                }
              }
              // If the user is signing in with Google then we will not create personalMeetingID (Sign In Condition)
              else {
                // Fetch current userId info from "users" collection
                final currentUserInfo = await _db
                    .collection("users")
                    .doc(_auth.currentUser!.uid)
                    .get();

                final userData = currentUserInfo.data();

                // Create "users" collection so we can store user-specific user data
                await _db.collection("users").doc(_auth.currentUser!.uid).set({
                  "name": userCredential.additionalUserInfo!.profile!["name"],
                  "email":
                      userCredential.additionalUserInfo!.profile!["email"],
                  "imageUrl":
                      userCredential.additionalUserInfo!.profile!["picture"],
                  "provider": "Google",
                  "userID": _auth.currentUser!.uid,
                  "personalMeetingID": userData!["personalMeetingID"],
                }).then((value) {
                  debugPrint("User data saved in Firestore users collection");
                }).catchError((error) {
                  debugPrint("User data not saved!");
                });

                // Create an instance of Shared Preferences
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                //* Sixth, write current User info data to SharedPreferences
                await prefs.setString("name", userData["name"]);
                await prefs.setString("email", userData["email"]);
                await prefs.setString("imageUrl", userData["imageUrl"]);
                await prefs.setString("provider", userData["provider"]);
                await prefs.setString("userID", userData["userID"]);
                await prefs.setString(
                    "personalMeetingID", userData["personalMeetingID"]);

                //* Seventh, set isLogin to "true"
                await prefs.setBool('isLogin', true);

                //* Ninth, after successfully signing in/signing up redirect the user to the HomePage
                if (context.mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    RoutesNames.homePage,
                    (Route<dynamic> route) => false,
                  );
                }
              }
            }

            //? Handle exceptions for storing user info at Firestore DB
            on FirebaseAuthException catch (error) {
              if (error.message ==
                      "A network error (such as timeout, interrupted connection or unreachable host) has occurred." &&
                  context.mounted) {
                PopUpWidgets.diologbox(
                  context: context,
                  title: "Network failure",
                  content:
                      "Connection failed. Please check your network connection and try again.",
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

            //? If "userCredential.additionalUserInfo!.isNewUser" is "isNewUser" it means the user account is not present on our Firebase sign-in
            //? console it means the user is being signed in/signed up with Google for the first time so we can store the information in Firestore "users" collection.
            //? This code is used to detect when a user logs in with Google Provider for the first time and we can run some kind of logic on it.

            // if (userCredential.additionalUserInfo!.isNewUser) {}
          }
        }
      }
    }
    //? Handle errors related to Google SignIn/SignUp
    on FirebaseAuthException catch (error) {
      if (error.message ==
              "A network error (such as timeout, interrupted connection or unreachable host) has occurred." &&
          context.mounted) {
        Navigator.pop(context);
        PopUpWidgets.diologbox(
          context: context,
          title: "Network failure",
          content:
              "Connection failed. Please check your network connection and try again.",
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
  // Methods related to Facebook Auth
  // ----------------------------

  //! Method for Facebook Sign-In/Sign-Up
  static Future<void> signInwithFacebook(
      {required BuildContext context}) async {
    try {
      // Show Progress Indicator
      if (context.mounted) {
        ProgressIndicators.showProgressIndicator(context);
      }

      //* First, this code pops the Facebook signIn/signUp page in the browser on Android
      //* and if we are a web app then open Pop-Up Facebook signIn/signUp interface/UI in the web browser
      final LoginResult loginResult = await FacebookAuth.instance.login();

      //! If the user clicks on the back button while the Facebook Auth Browser Popup is showing or dismisses the Facebook Auth Browser PopUp by clicking anywhere on the screen then this code
      //! will pop out the Progress Indicator.
      if (loginResult.accessToken == null && context.mounted) {
        Navigator.of(context).pop();
      }

      //! If the user does nothing and continues to Facebook Auth browser Sign In then this code will be executed.
      else {
        //* Second, when the user gets login after entering their login password then this code retrieves the FacebookTokenData.
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

        // If accessToken or idToken is null then return nothing.
        if (loginResult.accessToken == null) {
          return;
        }
        // If accessToken and idToken are not null only then we process to login
        else {
          //* Third, this method signs in the user with credentials
          final UserCredential userCredentail =
              await _auth.signInWithCredential(facebookAuthCredential);

          //* Fourth, store user info inside the Firestore "users" collection.
          // ? Try & catch block for storing user info at Firestore in "users" collections
          try {
            // Check whether the user is already signed up or not
            var signUpStatus =
                await FirebaseAuthMethods.isSignUpforFirstTime();

            // If the user is continuing with Facebook Sign up then only we create personalMeetingID (Sign UP Condition)
            if (signUpStatus.signUpWithFacebook) {
              // Create "users" collection so we can store user-specific user data
              await _db.collection("users").doc(_auth.currentUser!.uid).set({
                "name": userCredentail.additionalUserInfo!.profile!["name"],
                "email": userCredentail.additionalUserInfo!.profile!["email"],
                "imageUrl": userCredentail.additionalUserInfo!
                    .profile!["picture"]["data"]["url"],
                "provider": "Facebook",
                "userID": _auth.currentUser!.uid,
                "personalMeetingID": generate12DigitNumber(),
              }).then((value) {
                debugPrint("User data saved in Firestore users collection");
              }).catchError((error) {
                debugPrint("User data not saved!");
              });

              // Fetch current userId info from "users" collection
              final currentUserInfo = await _db
                  .collection("users")
                  .doc(_auth.currentUser!.uid)
                  .get();

              final userData = currentUserInfo.data();

              // Create an instance of Shared Preferences
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              //* Fifth, write current User info data to SharedPreferences
              await prefs.setString("name", userData!["name"]);
              await prefs.setString("email", userData["email"]);
              await prefs.setString("imageUrl", userData["imageUrl"]);
              await prefs.setString("provider", userData["provider"]);
              await prefs.setString("userID", userData["userID"]);
              await prefs.setString(
                  "personalMeetingID", userData["personalMeetingID"]);

              //* Sixth, set isLogin to "true"
              await prefs.setBool('isLogin', true);

              //* Seventh, after successfully signing in/signing up we set the isSignUpforFirstTime shared preference value to true.
              await prefs.setBool('signUpWithFacebook', false);

              //* Eighth, after successfully signing in redirect the user to the HomePage
              if (context.mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RoutesNames.homePage,
                  (Route<dynamic> route) => false,
                );
              }
            }
            // If the user is signing in with Google then we will not create personalMeetingID (Sign In Condition)
            else {
              // Fetch current userId info from "users" collection
              final currentUserInfo = await _db
                  .collection("users")
                  .doc(_auth.currentUser!.uid)
                  .get();

              final userData = currentUserInfo.data();

              // Create "users" collection so we can store user-specific user data
              await _db.collection("users").doc(_auth.currentUser!.uid).set({
                "name": userCredentail.additionalUserInfo!.profile!["name"],
                "email": userCredentail.additionalUserInfo!.profile!["email"],
                "imageUrl": userCredentail.additionalUserInfo!
                    .profile!["picture"]["data"]["url"],
                "provider": "Facebook",
                "userID": _auth.currentUser!.uid,
                "personalMeetingID": userData!["personalMeetingID"],
              }).then((value) {
                debugPrint("User data saved in Firestore users collection");
              }).catchError((error) {
                debugPrint("User data not saved!");
              });

              // Create an instance of Shared Preferences
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              //* Sixth, write current User info data to SharedPreferences
              await prefs.setString("name", userData["name"]);
              await prefs.setString("email", userData["email"]);
              await prefs.setString("imageUrl", userData["imageUrl"]);
              await prefs.setString("provider", userData["provider"]);
              await prefs.setString("userID", userData["userID"]);
              await prefs.setString(
                  "personalMeetingID", userData["personalMeetingID"]);

              //* Seventh, set isLogin to "true"
              await prefs.setBool('isLogin', true);

              //* Eighth, after successfully signing in/signing up redirect the user to the HomePage
              if (context.mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RoutesNames.homePage,
                  (Route<dynamic> route) => false,
                );
              }
            }
          }

          //? Handle exceptions for storing user info at Firestore DB
          on FirebaseAuthException catch (error) {
            if (error.message ==
                    "A network error (such as timeout, interrupted connection or unreachable host) has occurred." &&
                context.mounted) {
              PopUpWidgets.diologbox(
                context: context,
                title: "Network failure",
                content:
                    "Connection failed. Please check your network connection and try again.",
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

    //? Handle errors related to Facebook SignIn/SignUp
    on FirebaseAuthException catch (error) {
      if (error.message ==
              "A network error (such as timeout, interrupted connection or unreachable host) has occurred." &&
          context.mounted) {
        PopUpWidgets.diologbox(
          context: context,
          title: "Network failure",
          content:
              "Connection failed. Please check your network connection and try again.",
        );
      } else if (error.message ==
              "[firebase_auth/account-exists-with-different-credential] An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address." &&
          context.mounted) {
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
  // Methods related to Twitter Auth
  // ---------------------------

  //! Method for Twitter Sign-In/Sign-Up
  static Future<void> singInwithTwitter(
      {required BuildContext context}) async {
    try {
      //? --------------------------
      //? Twitter Auth code for Web
      //? --------------------------
      if (kIsWeb) {
        //* First, create a twitterProvider instance with the help of the TwitterAuthProvider class constructor
        TwitterAuthProvider twitterProvider = TwitterAuthProvider();

        //* Second, this code pops the Twitter signIn/signUp interface/UI in the user's browser
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithPopup(twitterProvider);

        if (context.mounted) {
          ProgressIndicators.showProgressIndicator(context);
        }

        //* Third, store user info inside the Firestore "users" collection.
        // ? Try & catch block for storing user info at Firestore in "users" collections
        try {
          // Create "users" collection so we can store user-specific user data
          await _db.collection("users").doc(_auth.currentUser!.uid).set({
            "name": userCredential.additionalUserInfo!.profile!["name"],
            "email": userCredential.additionalUserInfo!.profile!["email"],
            "imageUrl": userCredential
                .additionalUserInfo!.profile!["profile_image_url_https"],
            "provider": "Twitter",
            "userID": _auth.currentUser!.uid,
            "personalMeetingID": generate12DigitNumber(),
          }).then((value) {
            debugPrint("User data saved in Firestore users collection");
          }).catchError((error) {
            debugPrint("User data not saved!");
          });

          // Fetch current userId info from "users" collection
          final currentUserInfo = await _db
              .collection("users")
              .doc(_auth.currentUser!.uid)
              .get();

          final userData = currentUserInfo.data();

          // Create an instance of Shared Preferences
          final SharedPreferences prefs =
              await SharedPreferences.getInstance();

          //* Fourth, write current User info data to SharedPreferences
          await prefs.setString("name", userData!["name"]);
          await prefs.setString("email", userData["email"]);
          await prefs.setString("imageUrl", userData["imageUrl"]);
          await prefs.setString("provider", userData["provider"]);
          await prefs.setString("userID", userData["userID"]);
          await prefs.setString(
              "personalMeetingID", userData["personalMeetingID"]);

          //* Fifth, set isLogin to "true"
          await prefs.setBool('isLogin', true);
        }

        //? Handle exceptions for storing user info at Firestore DB
        on FirebaseAuthException catch (error) {
          if (error.message ==
                  "A network error (such as timeout, interrupted connection or unreachable host) has occurred." &&
              context.mounted) {
            PopUpWidgets.diologbox(
              context: context,
              title: "Network failure",
              content:
                  "Connection failed. Please check your network connection and try again.",
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

        //* Sixth, after successfully signing in redirect the user to the HomePage
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
        //* First, create a twitterProvider instance with the help of the TwitterAuthProvider class constructor
        TwitterAuthProvider twitterProvider = TwitterAuthProvider();

        // Showing Progress Indicator
        if (context.mounted) {
          ProgressIndicators.showProgressIndicator(context);
        }

        //* Second, this code pops the Twitter signIn/signUp interface/UI in the user's browser
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithProvider(twitterProvider);

        //! If the user clicks on the back button while the Twitter OAuth Popup is showing or dismisses the Twitter OAuth Pop by clicking anywhere on the screen then this code
        //! will pop out the Progress Indicator.
        if (userCredential.additionalUserInfo == null && context.mounted) {
          Navigator.of(context).pop();
        }

        //! If the user does nothing and continues to Twitter OAuth Sign In then this code will be executed.
        else {
          //* Third, store user info inside the Firestore "users" collection.
          // ? Try & catch block for storing user info at Firestore in "users" collections
          try {
            // Check whether the user is already signed up or not
            var signUpStatus =
                await FirebaseAuthMethods.isSignUpforFirstTime();

            if (signUpStatus.signUpWithTwitter) {
              // Create "users" collection so we can store user-specific user data
              await _db.collection("users").doc(_auth.currentUser!.uid).set({
                "name": userCredential.additionalUserInfo!.profile!["name"],
                "email": userCredential.additionalUserInfo!.profile!["email"],
                "imageUrl": userCredential
                    .additionalUserInfo!.profile!["profile_image_url_https"],
                "provider": "Twitter",
                "userID": _auth.currentUser!.uid,
                "personalMeetingID": generate12DigitNumber(),
              }).then((value) {
                debugPrint("User data saved in Firestore users collection");
              }).catchError((error) {
                debugPrint("User data not saved!");
              });

              // Fetch current userId info from "users" collection
              final currentUserInfo = await _db
                  .collection("users")
                  .doc(_auth.currentUser!.uid)
                  .get();

              final userData = currentUserInfo.data();

              // Create an instance of Shared Preferences
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              //* Fourth, write current User info data to SharedPreferences
              await prefs.setString("name", userData!["name"]);
              await prefs.setString("email", userData["email"]);
              await prefs.setString("imageUrl", userData["imageUrl"]);
              await prefs.setString("provider", userData["provider"]);
              await prefs.setString("userID", userData["userID"]);
              await prefs.setString(
                  "personalMeetingID", userData["personalMeetingID"]);

              //* Fifth, set isLogin to "true"
              await prefs.setBool('isLogin', true);

              //* Sixth, after successfully signing in/signing up we set the isSignUpforFirstTime shared preference value to true.
              await prefs.setBool('signUpWithTwitter', false);

              //* Seventh, after successfully signing in redirect the user to the HomePage
              if (context.mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RoutesNames.homePage,
                  (Route<dynamic> route) => false,
                );
              }
            }
            // If the user is signing in with Google then we will not create personalMeetingID (Sign In Condition)
            else {
              // Fetch current userId info from "users" collection
              final currentUserInfo = await _db
                  .collection("users")
                  .doc(_auth.currentUser!.uid)
                  .get();

              final userData = currentUserInfo.data();

              // Create "users" collection so we can store user-specific user data
              await _db.collection("users").doc(_auth.currentUser!.uid).set({
                "name": userCredential.additionalUserInfo!.profile!["name"],
                "email": userCredential.additionalUserInfo!.profile!["email"],
                "imageUrl": userCredential
                    .additionalUserInfo!.profile!["profile_image_url_https"],
                "provider": "Twitter",
                "userID": _auth.currentUser!.uid,
                "personalMeetingID": userData!["personalMeetingID"],
              }).then((value) {
                debugPrint("User data saved in Firestore users collection");
              }).catchError((error) {
                debugPrint("User data not saved!");
              });

              // Create an instance of Shared Preferences
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              //* Fourth, write current User info data to SharedPreferences
              await prefs.setString("name", userData["name"]);
              await prefs.setString("email", userData["email"]);
              await prefs.setString("imageUrl", userData["imageUrl"]);
              await prefs.setString("provider", userData["provider"]);
              await prefs.setString("userID", userData["userID"]);
              await prefs.setString(
                  "personalMeetingID", userData["personalMeetingID"]);

              //* Fifth, set isLogin to "true"
              await prefs.setBool('isLogin', true);

              //* Sixth, after successfully signing in redirect the user to the HomePage
              if (context.mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RoutesNames.homePage,
                  (Route<dynamic> route) => false,
                );
              }
            }
          }

          //? Handle exceptions for storing user info at Firestore DB
          on FirebaseAuthException catch (error) {
            if (error.message ==
                    "A network error (such as timeout, interrupted connection or unreachable host) has occurred." &&
                context.mounted) {
              PopUpWidgets.diologbox(
                context: context,
                title: "Network failure",
                content:
                    "Connection failed. Please check your network connection and try again.",
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
    //? Handle errors related to Google SignIn/SignUp
    on FirebaseAuthException catch (error) {
      if (error.message ==
              "A network error (such as timeout, interrupted connection or unreachable host) has occurred." &&
          context.mounted) {
        Navigator.of(context).pop();
        PopUpWidgets.diologbox(
          context: context,
          title: "Network failure",
          content:
              "Connection failed. Please check your network connection and try again.",
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
  // Methods related to Firebase Auth SignOut
  // ------------------------------------

  //! Method for SignOut Firebase Provider auth account
  static Future<void> singOut({required BuildContext context}) async {
    try {
      // Remove the entries of Shared Preferences data
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('birthYear');
      prefs.remove('name');
      prefs.remove('email');
      prefs.remove('imageUrl');
      prefs.remove('provider');
      prefs.remove('userID');

      // Set isLogin to false
      await prefs.setBool('isLogin', false);

      // SignOut code for Google SignIn/SignUp
      if (await GoogleSignIn().isSignedIn()) {
        // Sign out the user from Google account
        GoogleSignIn().signOut();
      }

      // This method signs out the user from all Firebase auth Providers
      await _auth.signOut();

      // Redirecting user to Welcome Page
      if (context.mounted) {
        Navigator.of(context).pushNamed(
          RoutesNames.welcomePage,
        );
      }
    }
    //? Handle errors related to Google SignIn/SignUp
    on FirebaseAuthException catch (error) {
      if (error.message ==
              "A network error (such as timeout, interrupted connection or unreachable host) has occurred." &&
          context.mounted) {
        Navigator.of(context).pop();
        PopUpWidgets.diologbox(
          context: context,
          title: "Sign up failed",
          content:
              "Connection failed. Please check your network connection and try again.",
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
  // Methods for checking if the app is opened for the first time
  // -----------------------------------------------

  //! Here we retrieve the details of whether the application is opened for the first time or not.
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
  // Method to Retrieve User Authentication Status
  // -----------------------------------------

  //! Method that checks if the user is logged in or not with any Provider.
  static Future<bool> isUserLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    return isLogin;
  }

  //! Method for fetching Data.
  static Future<Map<String, dynamic>?> getUserData() async {
    final currentUserInfo =
        await _db.collection("users").doc(_auth.currentUser!.uid).get();
    final userData = currentUserInfo.data();
    return userData;
  }
}
