import 'package:flutter/material.dart';

Color kScaffoldColor(context) => Theme.of(context).colorScheme.surface;

Color kHeadingColor(context) => Theme.of(context).colorScheme.primary;

Color kRedColor(context) => Theme.of(context).colorScheme.background;

TextStyle kHeadingStyle(context) => TextStyle(
      color: kHeadingColor(context),
      fontSize: 36,
      fontWeight: FontWeight.w700,
    );

TextStyle kSubHeading(context) => TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    );

TextStyle kNormalText(context) => TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    );

TextStyle kButtonTextStyle(context) => TextStyle(
      color: Theme.of(context).colorScheme.background,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

TextStyle kSnackbarContentTextStyle(context) => const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w300,
    );

OutlineInputBorder outlineInputBorder(color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: color),
    );

ThemeData darkThemeData = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff6a7a94),
      onPrimary: Color(0xffffbfa7),
      secondary: Color(0xffffc3a1),
      onSecondary: Color(0xfff3f5f7),
      error: Color(0xffe63050),
      onError: Color(0xffcfacb8),
      background: Color(0xfff24774),
      onBackground: Color(0xff655eb0),
      surface: Color(0xff0f0f0f),
      onSurface: Color(0xffe3dee4),
    ),
    primaryColor: const Color(0xff0f0f0f),
    canvasColor: const Color(0xfff3f5f7),
    backgroundColor: const Color(0xff334e6a),
    fontFamily: 'RobotoCondensed');

ThemeData lightThemeData = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff6a7a94),
      onPrimary: Color(0xffffbfa7),
      secondary: Color(0xffffc3a1),
      onSecondary: Color(0xfff3f5f7),
      error: Color(0xffe63050),
      onError: Color(0xffcfacb8),
      background: Color(0xfff24774),
      onBackground: Color(0xff655eb0),
      surface: Color(0xffeae5f8),
      onSurface: Color(0xff000000),
    ),
    primaryColor: const Color(0xfff3f5f7),
    canvasColor: const Color(0xff0f0f0f),
    backgroundColor: const Color(0xffeae5f8),
    fontFamily: 'RobotoCondensed');

InputDecoration kTextFieldInputDecoration(context, labelText, hintText) =>
    InputDecoration(
      constraints: const BoxConstraints(maxHeight: 45, minHeight: 45),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      labelText: labelText,
      labelStyle: kNormalText(context)
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
      hintText: hintText,
      hintStyle: kNormalText(context).copyWith(color: kHeadingColor(context)),
      border: outlineInputBorder(Colors.white),
      focusedBorder: outlineInputBorder(Colors.white),
      errorBorder: outlineInputBorder(kRedColor(context)),
    );
