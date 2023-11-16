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
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          return const ToDoListScreen();
        }
        if (!snapshot.hasData) {
          return const LoginScreen();
        }
        return const CircularProgressIndicator();
      },
    );
    ;
  }
}
