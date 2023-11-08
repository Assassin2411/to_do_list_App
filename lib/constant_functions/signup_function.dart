import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/main.dart';
import 'package:to_do_list/model/profile_model.dart';
import 'package:to_do_list/widgets/custom_snackbar.dart';

final RegExp emailRegExp =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
final RegExp passwordRegExp =
    RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$');

signup(enteredName, enteredEmail, enteredPassword, profileUrl, fcmToken,
    latitude, longitude, context) async {
  if (enteredName.isEmpty || enteredEmail.isEmpty || enteredPassword.isEmpty) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: CustomSnackbar(
          heading: 'Try again!',
          content: "Fields can't be empty 😒",
        ),
      ),
    );
    return;
  }
  if (enteredName.length < 3) {
    ScaffoldMessenger.of(context).clearSnackBars();
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
  if (!emailRegExp.hasMatch(enteredEmail)) {
    ScaffoldMessenger.of(context).clearSnackBars();
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
  if (!passwordRegExp.hasMatch(enteredPassword)) {
    ScaffoldMessenger.of(context).clearSnackBars();
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

  try {
    UserCredential userCredentials =
        await firebaseAuth.createUserWithEmailAndPassword(
      email: enteredEmail,
      password: enteredPassword,
    );
    final userId = userCredentials.user!.uid;
    ProfileModel profile = ProfileModel(
      id: userId,
      name: enteredName,
      email: enteredEmail,
      profileUrl: profileUrl,
      fcmToken: fcmToken,
      latitude: latitude,
      longitude: longitude,
      dateOfBirth: DateTime.now(),
      accountCreatedDate: DateTime.now(),
      lastOnline: DateTime.now(), // Get this from user input
      // Set other fields as necessary
    );
    await fireStore.collection('users').doc(userId).set(profile.toMap());
  } on FirebaseAuthException catch (error) {
    showError(context, error);
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
