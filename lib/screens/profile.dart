import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const title = 'Profile';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(ProfilePage.title),
    ));
  }
}
