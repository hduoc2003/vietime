import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vietime/entity/card.dart';
import 'package:vietime/screens/study_screen.dart';

import '../custom_widgets/editable_text_area.dart';
import '../custom_widgets/long_button.dart';
import '../custom_widgets/password_field_toggle.dart';
import '../helpers/api.dart';
import '../helpers/loader_dialog.dart';
import '../services/api_handler.dart';

class SignUpPage extends StatefulWidget {
  final Function onResetHomePage;
  SignUpPage({required this.onResetHomePage});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String signupError = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng ký tài khoản"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EditableTextArea(
                    title: 'Tên người dùng',
                    controller: userNameController,
                    hintText: "Nhập tên người dùng",
                  ),
                  SizedBox(height: 16.0),
                  EditableTextArea(
                    title: 'Email',
                    controller: emailController,
                    hintText: "Nhập địa chỉ email",
                  ),
                  SizedBox(height: 16.0),
                  PasswordFieldWithToggle(
                    title: 'Mật khẩu',
                    controller: passwordController,
                    hintText: "Nhập mật khẩu",
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  PasswordFieldWithToggle(
                    title: 'Xác nhận mật khẩu',
                    controller: confirmPasswordController,
                    hintText: "Nhập lại mật khẩu",
                  ),
                ]),
          ),
          if (signupError.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  signupError,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20),
            child: LongButton(
              text: 'ĐĂNG KÝ',
              outerBoxColor: Color(0xff1783d1),
              innerBoxColor: Color(0xff46a4e8),
              textColor: Colors.white,
              onTap: () {
                if (userNameController.text.isEmpty) {
                  setState(() {
                    signupError = "Tên người dùng không được để trống";
                  });
                  return;
                }
                if (emailController.text.length < 8 ||
                    passwordController.text.length < 8) {
                  setState(() {
                    signupError = "Email và mật khẩu phải có ít nhất 8 kí tự";
                  });
                  return;
                }
                if (passwordController.text != confirmPasswordController.text) {
                  setState(() {
                    signupError =
                        "Mật khẩu và mật khẩu xác nhận phải giống nhau";
                  });
                  return;
                }
                FocusManager.instance.primaryFocus?.unfocus();
                showLoaderDialog(context);
                APIHelper.submitSignupRequest(userNameController.text,
                    emailController.text, passwordController.text)
                    .then((signupResponse) {
                  if (signupResponse.containsKey("error")) {
                    Navigator.pop(context);
                    setState(() {
                      signupError = signupResponse["error"]!;
                    });
                  } else {
                    GetIt.I<APIHanlder>().assignInitData(signupResponse);
                    GetIt.I<APIHanlder>().afterInitData();
                    Navigator.pop(context);
                    GetIt.I<APIHanlder>().isLoggedIn.value = true;
                    Navigator.pop(context);
                    widget.onResetHomePage();
                  }
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Đã có tài khoản?',
                style: TextStyle(fontSize: 18),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ĐĂNG NHẬP',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
