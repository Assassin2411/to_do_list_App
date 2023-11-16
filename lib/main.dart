import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list/constants/styling.dart';
import 'package:to_do_list/screens/login_screen.dart';
import 'package:to_do_list/screens/profile_screen.dart';
import 'package:to_do_list/screens/todo_list_screen.dart';
import 'package:to_do_list/widgets/navigator_page.dart';

final firebaseAuth = FirebaseAuth.instance;
final fireStore = FirebaseFirestore.instance;
final firebaseMessaging = FirebaseMessaging.instance;
final fireStorage = FirebaseStorage.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class ThemeChangeNotifier extends StatefulWidget {
  final Widget child;

  const ThemeChangeNotifier({super.key, required this.child});

  @override
  State<ThemeChangeNotifier> createState() => _ThemeChangeNotifierState();

  static _ThemeChangeNotifierState? of(BuildContext context) {
    final inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedTheme>();
    return inheritedTheme?.notifier;
  }
}

class _ThemeChangeNotifierState extends State<ThemeChangeNotifier> {
  ThemeMode _themeMode = ThemeMode.system;

  set themeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
    // Update the system navigation bar color here based on the new theme mode
    updateSystemNavBarColor(_themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedTheme(
      notifier: this,
      child: widget.child,
    );
  }
}

class _InheritedTheme extends InheritedWidget {
  final _ThemeChangeNotifierState notifier;

  const _InheritedTheme({required Widget child, required this.notifier})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

void updateSystemNavBarColor(ThemeMode themeMode) {
  final isDarkMode = themeMode == ThemeMode.dark;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor:
        isDarkMode ? Colors.black : const Color(0xffeae5f8),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeChangeNotifier(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: lightThemeData,
        darkTheme: darkThemeData,
        themeMode: ThemeChangeNotifier.of(context)?._themeMode,
        debugShowCheckedModeBanner: false,
        initialRoute: NavigatorPage.routeName,
        routes: {
          ToDoListScreen.routeName: (context) => const ToDoListScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          NavigatorPage.routeName: (context) => const NavigatorPage(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
