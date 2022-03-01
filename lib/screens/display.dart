import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class DisplayPage extends StatefulWidget {
  const DisplayPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  List<SizedBox> _list = [];

  Future<List<SizedBox>> _updateChords() async {
    // This simply returns the body of the chords webpage
    Future<Document> _fetchChords() async {
      final _url = ModalRoute.of(context)!.settings.arguments as String;
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
    _updateChords().then((value) {
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
        title: Text(widget.title),
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
