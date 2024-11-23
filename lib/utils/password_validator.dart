import 'package:flutter/material.dart';

class PasswordFieldValidator extends StatefulWidget {
  final int minLength;
  final int uppercaseCharCount;
  final int lowercaseCharCount;
  final int numericCharCount;

  final Color defaultColor;
  final Color successColor;
  final Color failureColor;
  final TextEditingController controller;

  final String? minLengthMessage;
  final String? uppercaseCharMessage;
  final String? lowercaseMessage;
  final String? numericCharMessage;

  const PasswordFieldValidator({
    super.key,
    required this.minLength,
    required this.uppercaseCharCount,
    required this.lowercaseCharCount,
    required this.numericCharCount,
    required this.defaultColor,
    required this.successColor,
    required this.failureColor,
    required this.controller,
    this.minLengthMessage,
    this.uppercaseCharMessage,
    this.lowercaseMessage,
    this.numericCharMessage,
  });

  @override
  PasswordFieldValidatorState createState() => PasswordFieldValidatorState();
}

class PasswordFieldValidatorState extends State<PasswordFieldValidator> {
  final Map<Validation, bool> _selectedCondition = {
    Validation.atLeast: false,
    Validation.uppercase: false,
    Validation.lowercase: false,
    Validation.numericCharacter: false,
  };

  late bool isFirstRun;

  void validate() {
    _selectedCondition[Validation.atLeast] = Validator().hasMinimumLength(
      widget.controller.text,
      widget.minLength,
    );

    _selectedCondition[Validation.uppercase] = Validator().hasMinimumUppercase(
      widget.controller.text,
      widget.uppercaseCharCount,
    );

    _selectedCondition[Validation.lowercase] = Validator().hasMinimumLowercase(
      widget.controller.text,
      widget.lowercaseCharCount,
    );

    _selectedCondition[Validation.numericCharacter] = Validator().hasMinimumNumericCharacters(
      widget.controller.text,
      widget.numericCharCount,
    );

    setState(() {
      return;
    });
  }

  @override
  void initState() {
    super.initState();
    isFirstRun = true;

    widget.controller.addListener(() {
      isFirstRun = false;
      validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _selectedCondition.entries.map((entry) {
        int conditionValue = 0;
        String conditionMessage = '';
        if (entry.key == Validation.atLeast) {
          conditionValue = widget.minLength;
          conditionMessage = widget.minLengthMessage ?? validatorMessage.entries.firstWhere((element) => element.key == Validation.atLeast).value.toString();
        }
        if (entry.key == Validation.uppercase) {
          conditionValue = widget.uppercaseCharCount;
          conditionMessage = widget.uppercaseCharMessage ?? validatorMessage.entries.firstWhere((element) => element.key == Validation.uppercase).value.toString();
        }
        if (entry.key == Validation.lowercase) {
          conditionValue = widget.lowercaseCharCount;
          conditionMessage = widget.lowercaseMessage ?? validatorMessage.entries.firstWhere((element) => element.key == Validation.lowercase).value.toString();
        }
        if (entry.key == Validation.numericCharacter) {
          conditionValue = widget.numericCharCount;
          conditionMessage = widget.numericCharMessage ?? validatorMessage.entries.firstWhere((element) => element.key == Validation.numericCharacter).value.toString();
        }

        return ValidatorItemWidget(
          conditionMessage,
          conditionValue,
          isFirstRun
              ? widget.defaultColor
              : entry.value
                  ? widget.successColor
                  : widget.failureColor,
          entry.value,
        );
      }).toList(),
    );
  }
}

//! Enums

enum Validation { atLeast, uppercase, lowercase, numericCharacter, specialCharacter }

//! String Validation

class StringValidation {
  static const atLeast = 'At least character';
  static const uppercase = 'Uppercase letter';
  static const lowercase = 'Lowercase letter';
  static const numericCharacter = 'Numeric character';
  static const specialCharacter = 'Special character';
}

//! validator RegExp.

class Validator {
  //Check  minimum Length
  bool hasMinimumLength(String password, int minLength) {
    return password.length >= minLength ? true : false;
  }

  //Check numericCount
  bool hasMinimumNumericCharacters(String password, int numericCount) {
    String pattern = '^(.*?[0-9]){$numericCount,}';
    return password.contains(RegExp(pattern));
  }

  //Check lowercaseCount
  bool hasMinimumLowercase(String password, int lowercaseCount) {
    String pattern = '^(.*?[a-z]){$lowercaseCount,}';
    return password.contains(RegExp(pattern));
  }

  //Checks uppercaseCount
  bool hasMinimumUppercase(String password, int uppercaseCount) {
    String pattern = '^(.*?[A-Z]){$uppercaseCount,}';
    return password.contains(RegExp(pattern));
  }

  //Checks specialCharactersCount special character
  bool hasMinimumSpecialCharacters(String password, int specialCharactersCount) {
    // ignore: prefer_interpolation_to_compose_strings
    String pattern = r"^(.*?[$&+,\:;/=?@#|'<>.^*()_%!-]){" + specialCharactersCount.toString() + ",}";
    return password.contains(RegExp(pattern));
  }
}

//! Validation Message.

final Map<Validation, String> validatorMessage = {
  Validation.atLeast: StringValidation.atLeast,
  Validation.uppercase: StringValidation.uppercase,
  Validation.lowercase: StringValidation.lowercase,
  Validation.numericCharacter: StringValidation.numericCharacter,
  Validation.specialCharacter: StringValidation.specialCharacter,
};

//! validation UI.

@immutable
class ValidatorItemWidget extends StatelessWidget {
  final String text;
  final int conditionValue;
  final Color color;
  final bool value;

  const ValidatorItemWidget(this.text, this.conditionValue, this.color, this.value, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Container(
            child: value
                ? Icon(
                    Icons.check_circle_outline,
                    color: color,
                  )
                : Icon(
                    Icons.close_outlined,
                    color: color,
                  ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Text(
              '$text (${conditionValue.toString()})',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
