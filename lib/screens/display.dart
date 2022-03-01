import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'screens.dart';

class DisplayPage extends StatefulWidget {
  const DisplayPage({Key? key}) : super(key: key);

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  late ScreenArguments _args;
  List<SizedBox> _list = [];

  Future<List<SizedBox>> _updateChords(_url) async {
    // This simply returns the body of the chords webpage
    Future<Document> _fetchChords() async {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        return parse(response.body);
      } else {
        throw Exception('Failed to load album');
      }
    }

    // Download the chord's webpage
    var document = await _fetchChords();

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
    List<SizedBox> _outputList = [];
    for (int i = 0; i < lines.length; i++) {
      var format = Theme.of(context).textTheme.bodyText2;
      String lineToPrint = lines[i].trim();
      if (lineToPrint.substring(max(lineToPrint.length - 5, 0)) == '[/ch]') {
        format = Theme.of(context).textTheme.bodyText1;
      }
      _outputList.add(SizedBox(
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

    return _outputList;
  }

  @override
  void didChangeDependencies() {
    _args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    _updateChords(_args.url).then((value) {
      // setState updates the state of the app so our change to the list will actually show
      setState(() {
        _list = value;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_args.title),
      ),
      body: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          return _list[index];
        },
      ),
    );
  }
}
