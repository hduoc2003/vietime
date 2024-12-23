import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:vietime/entity/card.dart';
import 'package:vietime/screens/signup_screen.dart';
import 'package:vietime/screens/study_screen.dart';

import '../custom_widgets/editable_text_area.dart';
import '../custom_widgets/long_button.dart';
import '../custom_widgets/password_field_toggle.dart';
import '../helpers/api.dart';
import '../helpers/loader_dialog.dart';
import '../services/api_handler.dart';

class LoginPage extends StatefulWidget {
  final Function onSuccessLogIn;
  LoginPage({required this.onSuccessLogIn});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String loginError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng nhập tài khoản"),
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
                ]),
          ),
          if (loginError.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  loginError,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                onPressed: () {
                  // Add the functionality for "Quên mật khẩu" here
                },
                child: Text(
                  'QUÊN MẬT KHẨU?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 20),
            child: LongButton(
              text: 'ĐĂNG NHẬP',
              outerBoxColor: Color(0xff1783d1),
              innerBoxColor: Color(0xff46a4e8),
              textColor: Colors.white,
              onTap: () async {
                if (emailController.text.isEmpty) {
                  setState(() {
                    loginError = "Email không được để trống";
                  });
                  return;
                }
                if (passwordController.text.length < 8) {
                  setState(() {
                    loginError = "Mật khẩu phải có ít nhất 8 kí tự";
                  });
                  return;
                }
                FocusManager.instance.primaryFocus?.unfocus();
                showLoaderDialog(context);
                APIHelper.submitLoginRequest(
                        emailController.text, passwordController.text)
                    .then((loginResponse) {
                  if (loginResponse.containsKey("error")) {
                    Navigator.pop(context);
                    setState(() {
                      loginError = loginResponse["error"]!;
                    });
                  } else {
                    GetIt.I<APIHanlder>().assignInitData(loginResponse);
                    GetIt.I<APIHanlder>().afterInitData();
                    Navigator.pop(context);
                    widget.onSuccessLogIn();
                  }

                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Chưa có tài khoản?',
                style: TextStyle(fontSize: 18),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to SignUpPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignUpPage(
                              onSuccessLogIn: widget.onSuccessLogIn,
                            )),
                  );
                },
                child: Text(
                  'ĐĂNG KÝ',
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
