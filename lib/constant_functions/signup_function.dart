import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/main.dart';
import 'package:to_do_list/model/profile_model.dart';
import 'package:to_do_list/model/todo_model.dart';
import 'package:to_do_list/widgets/custom_snackbar.dart';

final RegExp emailRegExp =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
final RegExp passwordRegExp =
    RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$');

signup(enteredName, enteredEmail, enteredPassword, newImage, fcmToken, latitude,
    longitude, context) async {
  String profileUrl = '';
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

    if (newImage != null) {
      String filePath =
          'users/$userId/${DateTime.now().millisecondsSinceEpoch}';
      await fireStorage.ref(filePath).putFile(newImage);
      profileUrl = await fireStorage.ref(filePath).getDownloadURL();
    }

    profile = ProfileModel(
      profileUrl: profileUrl,
      name: enteredName,
      email: enteredEmail,
      fcmToken: fcmToken,
      dobUpdate: false,
      latitude: latitude,
      longitude: longitude,
      dateOfBirth: DateTime.now(),
      accountCreatedDate: DateTime.now(),
      lastOnline: DateTime.now(),
      phoneUpdate: false,
      phoneNumber: "1234567890",
    );

    await fireStore.collection('users').doc(userId).set(profile.toMap());

    await fireStore
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc('todo')
        .set(todo.toMap());
  } on FirebaseAuthException catch (error) {
    showError(context, error);
  }
}

showError(context, error) {
  if (error.toString().contains('INVALID_LOGIN_CREDENTIALS')) {
    error = 'Incorrect email or password.';
  } else if (error.toString().contains('invalid-email')) {
    error = 'User does not exist';
  }

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
