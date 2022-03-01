import 'home.dart';
import 'display.dart';

class ScreenArguments {
  final String title;
  final String url;

  ScreenArguments(this.title, this.url);
}

var screenRoutes = {
  '/': (context) => const HomePage(),
  '/display': (context) => const DisplayPage(),
};
