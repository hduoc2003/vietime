import 'package:flutter/material.dart';
import 'package:vietime/custom_widgets/long_button.dart';
import 'package:vietime/custom_widgets/password_field_toggle.dart';

import '../screens/settings/change_password_screen.dart';
import '../services/theme_manager.dart';

class EditableTextArea extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool isPassword;
  bool locked;
  final String hintText;

  EditableTextArea(
      {required this.title,
      required this.controller,
      this.isPassword = false,
      this.hintText = "",
      this.locked = false});

  @override
  Widget build(BuildContext context) {
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            color: locked ? myColors.textFieldReadOnlyColor : Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: myColors.grey300!,
              width: 3.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: isPassword
                ? TextField(
                    controller: controller,
                    maxLines: 1,
                    obscureText: true,
                    obscuringCharacter: '●',
                    readOnly: true,
                    style: TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onTap: () {
                      if (isPassword) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangePasswordPage(),
                          ),
                        );
                      }
                    },
                  )
                : TextField(
                    controller: controller,
                    maxLines: 1,
                    style: TextStyle(fontSize: 18),
                    readOnly: locked,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle:
                          TextStyle(fontSize: 18.0, color: Colors.grey[400]!),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
