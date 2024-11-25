import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProgressIndicators {
  static void showProgressIndicator(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return PopScope(
          canPop: true, //! Set this to false once you debug your code.
          child: Center(
            child: LoadingAnimationWidget.progressiveDots(
              color: const Color.fromARGB(255, 135, 135, 135),
              size: 50,
            ),
          ),
        );
      },
    );
  }
}
