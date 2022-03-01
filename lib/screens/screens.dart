import 'home.dart';
import 'display.dart';

var screenRoutes = {
  '/': (context) => const HomePage(title: 'Chords'),
  '/display': (context) => const DisplayPage(title: 'Search'),
};
