import 'package:flutter/material.dart';

import '../services/theme_manager.dart';

class PasswordFieldWithToggle extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;

  PasswordFieldWithToggle({
    required this.controller,
    required this.title,
    this.hintText = "",
  });

  @override
  _PasswordFieldWithToggleState createState() =>
      _PasswordFieldWithToggleState();
}

class _PasswordFieldWithToggleState extends State<PasswordFieldWithToggle> {
  bool _passwordVisible = false;

  void _onTap() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: myColors.grey300!,
              width: 3.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              style: TextStyle(fontSize: 18),
              keyboardType: TextInputType.text,
              controller: widget.controller,
              obscureText: !_passwordVisible,
              obscuringCharacter: '●',
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle:
                TextStyle(fontSize: 18.0, color: Colors.grey[400]!),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    _onTap();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
