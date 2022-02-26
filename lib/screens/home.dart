import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String resultantHtml = "";
  List<SizedBox> list = [];

  Future<void> updateChords() async {
    // This simply returns the body of the chords webpage
    Future<Document> fetchChords() async {
      final response = await http.get(Uri.parse(
          'https://tabs.ultimate-guitar.com/tab/billie-eilish/lovely-chords-2371539'));

      if (response.statusCode == 200) {
        return parse(response.body);
      } else {
        throw Exception('Failed to load album');
      }
    }

    // Download the chord's webpage
    var document = await fetchChords();

    // Get the json of the lyrics & chords (with other data we don't need) from the HTML
    String? stringInHtml = document
        .getElementsByClassName('js-store')[0]
        .attributes['data-content'];
    var asJson = jsonDecode(stringInHtml ?? "");

    // Get lyrics & chords as string from the json
    var tabView = asJson['store']['page']['data']['tab_view'];
    String resultantString = tabView['wiki_tab']['content'];

    // Format chords
    List<String> lines = resultantString.split("\n");
    list = [];
    for (int i = 0; i < lines.length; i++) {
      var format = Theme.of(context).textTheme.bodyText2;
      String lineToPrint = lines[i].trim();
      if (lineToPrint.substring(max(lineToPrint.length - 5, 0)) == '[/ch]') {
        format = Theme.of(context).textTheme.bodyText1;
      }
      list.add(SizedBox(
        child: Text(
          lineToPrint // Remove all tags from output
              .replaceAll('[tab]', '')
              .replaceAll('[/tab]', '')
              .replaceAll('[ch]', '')
              .replaceAll('[/ch]', ''),
          style: format,
        ),
        width: MediaQuery.of(context).size.width,
      ));
    }
    resultantHtml = resultantString;

    // setState updates the state of the app so our change to resultantHtml will actually show
    setState(() {});
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
                  Text(
                    'Welcome, click the button bellow to get some lyrics & chords:',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    child: const Text('Get chords'),
                    onPressed: updateChords,
                  ),
                ] +
                list,
          ),
        ),
      ),
    );
  }
}
