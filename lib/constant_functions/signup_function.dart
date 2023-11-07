import 'package:flutter/material.dart';
import 'package:to_do_list/widgets/custom_snackbar.dart';

final RegExp _emailRegExp =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
final RegExp _passwordRegExp =
    RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$');

signup(enteredName, enteredEmail, enteredPassword, context) {
  if (enteredName.isEmpty || enteredEmail.isEmpty || enteredPassword.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: CustomSnackbar(
          heading: 'Try again!',
          content: "Field can't be empty 😒",
        ),
      ),
    );
    return;
  }
  if (enteredName.length < 3) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: CustomSnackbar(
          heading: 'Try again!',
          content: "Name is too short... 😒",
        ),
      ),
    );
    return;
  }
  if (!_emailRegExp.hasMatch(enteredEmail)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: CustomSnackbar(
          heading: 'Try again!',
          content: "Entered email is invalid! 😒",
        ),
      ),
    );
    return;
  }
  if (!_passwordRegExp.hasMatch(enteredPassword)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: CustomSnackbar(
          heading: 'Try again!',
          content:
              "Entered password have at least 8 characters and at least 1 special character! 😒",
        ),
      ),
    );
    return;
  }
}

showError(context, error) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: CustomSnackbar(
        heading: 'Authentication Failed',
        content: "$error 😒",
      ),
    ),
  );
}
