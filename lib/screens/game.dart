import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  static const title = 'Game';

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(GamePage.title),
    ));
  }
}
