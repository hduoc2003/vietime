import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  static const title = 'Search';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(SearchPage.title),
    ));
  }
}
