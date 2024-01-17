import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/screens/login_screen.dart';
import 'package:to_do_list/screens/todo_list_screen.dart';

class NavigatorPage extends StatelessWidget {
  const NavigatorPage({super.key});

  static String routeName = '/navigator_page';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const LoginScreen();
          } else {
            return const ToDoListScreen();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }
        // if (snapshot.connectionState == ConnectionState.active) {
        //   return const ToDoListScreen();
        // }
        // if (snapshot.connectionState != ConnectionState.active) {
        //   return const LoginScreen();
        // }
        // return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
