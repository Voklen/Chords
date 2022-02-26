import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/display.dart';
import 'theme.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chords',
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(title: 'Hallelujah Chords'),
        '/display': (context) => const DisplayPage(title: 'Search'),
        // '/third': (context) => ThirdRoute(),
      },
    );
  }
}
