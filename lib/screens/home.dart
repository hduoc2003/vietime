import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const title = 'Home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(HomePage.title),
    ));
  }
}
