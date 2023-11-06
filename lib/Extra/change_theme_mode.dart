// import 'package:flutter/material.dart';
//
// import '../main.dart';
//
// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final themeChangeNotifier = ThemeChangeNotifier.of(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dynamic Navigation Bar Color'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 themeChangeNotifier.themeMode =
//                     ThemeMode.light; // Change to light theme mode
//               },
//               child: const Text('Light Mode'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 themeChangeNotifier.themeMode =
//                     ThemeMode.dark; // Change to dark theme mode
//               },
//               child: const Text('Dark Mode'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 themeChangeNotifier.themeMode =
//                     ThemeMode.system; // Use system theme mode
//               },
//               child: const Text('System Mode'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
