import 'package:flutter/material.dart';

var lightTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFf8f8f8),
  primarySwatch: Colors.amber,
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontFamily: 'Drafting',
      backgroundColor: Color(0xFFdfdfdf),
      color: Color(0xFF212121),
    ),
    bodyText2: TextStyle(
      fontFamily: 'Drafting',
      color: Color(0xFF212121),
    ),
  ),
);

var darkTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFF111111),
  primarySwatch: Colors.amber,
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontFamily: 'Drafting',
      backgroundColor: Color(0xFF292929),
      color: Color(0xFFddddcc),
    ),
    bodyText2: TextStyle(
      fontFamily: 'Drafting',
      color: Color(0xFFddddcc),
    ),
    headline5: TextStyle(
      color: Color(0xFFddddcc),
    ),
  ),
);
