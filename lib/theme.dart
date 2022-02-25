import 'package:flutter/material.dart';

var lightTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFf8f8f8),
  primarySwatch: Colors.amber,
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontFamily: 'Drafting',
      backgroundColor: Color(0xFFdfdfdf),
    ),
    bodyText2: TextStyle(
      fontFamily: 'Drafting',
    ),
  ).apply(
    bodyColor: const Color(0xFF212121),
  ),
);

var darkTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFF111111),
  primarySwatch: Colors.amber,
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontFamily: 'Drafting',
      backgroundColor: Color(0xFF292929),
    ),
    bodyText2: TextStyle(
      fontFamily: 'Drafting',
    ),
    headline5: TextStyle(),
  ).apply(
    bodyColor: const Color(0xFFddddcc),
  ),
);
