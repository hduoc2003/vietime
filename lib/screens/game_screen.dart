import 'package:flutter/material.dart';
import 'package:vietime/entity/card.dart';
import 'package:vietime/screens/study_screen.dart';

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
      ),
    );
  }
}