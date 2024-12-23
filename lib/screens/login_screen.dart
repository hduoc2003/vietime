import 'package:flutter/material.dart';
import 'package:vietime/entity/card.dart';
import 'package:vietime/screens/study_screen.dart';

class LoginPage extends StatefulWidget {
  static const title = 'Login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LoginPage.title),
      ),
    );
  }
}
