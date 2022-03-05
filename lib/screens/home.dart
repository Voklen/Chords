import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'screens.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textController = TextEditingController();
  List<ResultCard> _list = [];

  Future<void> search() async {
    // This simply returns the body of the search's webpage
    Future<Document> fetchSearch() async {
      final response = await http.get(Uri.parse(
          'https://www.ultimate-guitar.com/search.php?search_type=title&value=' +
              _textController.text));

      if (response.statusCode == 200) {
        return parse(response.body);
      } else {
        throw Exception('Failed to load album');
      }
    }

    // Download the chord's webpage
    var document = await fetchSearch();

    // Get the json of the lyrics & chords (with other data we don't need) from the HTML
    String? stringInHtml = document
        .getElementsByClassName('js-store')[0]
        .attributes['data-content'];
    var asJson = jsonDecode(stringInHtml ?? "");

    // Get lyrics & chords as string from the json
    var resultsAsJson = asJson['store']['page']['data']['results'];
    var results = List.from(resultsAsJson);

    // Loop through results
    _list = [];
    for (int i = 0; i < results.length; i++) {
      var result = results[i];
      if (result['marketing_type'] != null) {
        // Don't add premium-only songs
        continue;
      }
      _list.add(ResultCard(
        artist: result['artist_name'],
        song: result['song_name'],
        rating: result['rating'].toString(),
        type: result['type'],
        url: result['tab_url'],
      ));
    }

    // setState updates the state of the app so our change to the list will actually show
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
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
                  _MainSearchBar(),
                  ElevatedButton(
                    child: const Text('Get results'),
                    onPressed: () {
                      search();
                    },
                  ),
                ] +
                _list,
          ),
        ),
      ),
    );
  }

  Widget _MainSearchBar() {
    return TextField(
      controller: _textController,
      decoration: InputDecoration(
          hintText: 'Enter search',
          hintStyle: Theme.of(context).textTheme.headline6,
          labelStyle: Theme.of(context).textTheme.headline6,
          border: const OutlineInputBorder(),
          // Clear button
          suffixIcon: IconButton(
            onPressed: () {
              _textController.clear();
            },
            icon: const Icon(Icons.clear),
          )),
      style: Theme.of(context).textTheme.headline6,
    );
  }
}

class ResultCard extends StatelessWidget {
  final String artist;
  final String song;
  final String rating;
  final String type;
  final String url;

  const ResultCard({
    required this.artist,
    required this.song,
    required this.rating,
    required this.type,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(artist),
            ),
            SizedBox(
              width: 110,
              child: Text(song),
            ),
            SizedBox(
              width: 61,
              child: Text(rating),
            ),
            SizedBox(
              width: 40,
              child: Text(type),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/display',
                    arguments: ScreenArguments(song, url),
                  );
                },
                child: const Text('Get chords'))
          ],
        )
      ],
    );
  }
}
