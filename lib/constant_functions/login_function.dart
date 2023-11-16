import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/constant_functions/signup_function.dart';
import 'package:to_do_list/main.dart';
import 'package:to_do_list/widgets/custom_snackbar.dart';

login(enteredEmail, enteredPassword, context) async {
  if (enteredEmail.isEmpty || enteredPassword.isEmpty) {
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
  // if (!emailRegExp.hasMatch(enteredEmail)) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       elevation: 0,
  //       backgroundColor: Colors.transparent,
  //       content: CustomSnackbar(
  //         heading: 'Try again!',
  //         content: "Entered email is invalid! 😒",
  //       ),
  //     ),
  //   );
  //   return;
  // }
  // if (!passwordRegExp.hasMatch(enteredPassword)) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       elevation: 0,
  //       backgroundColor: Colors.transparent,
  //       content: CustomSnackbar(
  //         heading: 'Try again!',
  //         content: "Entered password not matched 😒",
  //       ),
  //     ),
  //   );
  //   return;
  // }

  try {
    await firebaseAuth.signInWithEmailAndPassword(
      email: enteredEmail,
      password: enteredPassword,
    );
  } on FirebaseAuthException catch (error) {
    log('error: $error');
    showError(context, error);
  }
}
