import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chords',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Hallelujah Chords'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String resultantHtml = "";

  void updateChords() {
    // This simply returns the body of the chords webpage
    Future<Document> fetchChords() async {
      final response = await http.get(Uri.parse(
          'https://tabs.ultimate-guitar.com/tab/jeff-buckley/hallelujah-chords-198052'));

      if (response.statusCode == 200) {
        return parse(response.body);
      } else {
        throw Exception('Failed to load album');
      }
    }

    // setState updates the state of the app so our change to resultantHtml will actually show
    setState(() {
      fetchChords().then((document) {
        String? stringInHtml = document
            .getElementsByClassName('js-store')[0]
            .attributes['data-content'];

        var asJson = jsonDecode(stringInHtml ?? "");
        var tabView = asJson['store']['page']['data']['tab_view'];
        resultantHtml = tabView['wiki_tab']['content'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                resultantHtml,
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: updateChords,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
