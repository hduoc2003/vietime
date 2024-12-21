import 'package:flutter/material.dart';

import '../custom_widgets/editable_text_area.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController textArea1Controller =
      TextEditingController(text: "HynDuf");
  TextEditingController textArea2Controller =
      TextEditingController(text: "hynduf@gmail.com");
  TextEditingController textArea3Controller =
      TextEditingController(text: "...");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      EditableTextArea(
                        title: 'Tên người dùng',
                        controller: textArea1Controller,
                      ),
                      SizedBox(height: 16.0),
                      EditableTextArea(
                        title: 'Email',
                        controller: textArea2Controller,
                      ),
                      SizedBox(height: 16.0),
                      EditableTextArea(
                        title: 'Mật khẩu',
                        controller: textArea3Controller,
                        isPassword: true,
                      ),
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 32,
            ),
            onPressed: () {
              // Handle back button press
              Navigator.pop(context);
            },
          ),
          Text(
            '  Cài đặt',
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
          TextButton(
            onPressed: () {
              // Handle save button press
              print('Save button pressed');
            },
            child: Text(
              'LƯU',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
