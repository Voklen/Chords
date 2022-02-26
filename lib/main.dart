import 'package:flutter/material.dart';

import 'screens/home.dart' as home;
import 'theme.dart' as theme;

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chords',
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const home.HomePage(title: 'Hallelujah Chords'),
        // '/second': (context) => SecondRoute(),
        // '/third': (context) => ThirdRoute(),
      },
    );
  }
}
