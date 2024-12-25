import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:vietime/custom_widgets/long_button.dart';
import '../../custom_widgets/editable_text_area.dart';
import '../../custom_widgets/error_dialog.dart';
import '../../custom_widgets/snackbar.dart';
import '../../helpers/api.dart';
import '../../helpers/country_code.dart';
import '../../helpers/loader_dialog.dart';
import '../../main.dart';
import '../../services/api_handler.dart';

class SettingsPage extends StatefulWidget {
  final Function setDarkMode;
  final Function setLightMode;
  SettingsPage({required this.setDarkMode, required this.setLightMode});
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Box settingsBox = Hive.box('settings');
  String lang =
      Hive.box('settings').get('language', defaultValue: 'Vietnam') as String;
  bool isDarkMode =
      Hive.box('settings').get('darkMode', defaultValue: false) as bool;

  TextEditingController userNameController =
      TextEditingController(text: GetIt.I<APIHanlder>().user.name);
  TextEditingController emailController =
      TextEditingController(text: GetIt.I<APIHanlder>().user.email);
  TextEditingController passwordController =
      TextEditingController(text: "........");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              onSave: () {
                showLoaderDialog(context);
                APIHelper.submitUpdateUserRequest(userNameController.text)
                    .then((updateUserResponse) {
                  if (updateUserResponse.containsKey("error")) {
                    Navigator.pop(context);
                    ErrorDialog.show(context);
                  } else {
                    GetIt.I<APIHanlder>()
                        .onUpdateUserSuccess(updateUserResponse);
                    ShowSnackBar().showSnackBar(
                      context,
                      "Đã cập nhật thông tin thành công",
                      noAction: true,
                    );
                    Navigator.pop(context);
                  }
                });
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          EditableTextArea(
                            title: 'Tên người dùng',
                            controller: userNameController,
                          ),
                          SizedBox(height: 16.0),
                          EditableTextArea(
                            title: 'Email',
                            controller: emailController,
                            locked: true,
                          ),
                          SizedBox(height: 16.0),
                          EditableTextArea(
                            title: 'Mật khẩu',
                            controller: passwordController,
                            isPassword: true,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Divider(),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Cài đặt chung",
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SwitchListTile(
                            title: const Text(
                              'Chế độ tối',
                              style: TextStyle(fontSize: 20),
                            ),
                            value: isDarkMode,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (bool value) {
                              setState(() {
                                isDarkMode ^= true;
                                if (isDarkMode) {
                                  widget.setDarkMode();
                                } else {
                                  widget.setLightMode();
                                }
                                Hive.box('settings')
                                    .put('darkMode', isDarkMode);
                              });
                            },
                            secondary: const Iconify(
                              IconParkSolid.dark_mode,
                              color: Colors.purple,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              "Ngôn ngữ",
                              style: const TextStyle(fontSize: 20),
                            ),
                            leading: Iconify(Ion.language, color: Theme.of(context).iconTheme.color,),
                            contentPadding: EdgeInsets.zero,
                            onTap: () {},
                            trailing: DropdownButton(
                              value: lang,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              underline: const SizedBox(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(
                                    () {
                                      lang = newValue;
                                      // MyApp.of(context).setLocale(
                                      //   Locale.fromSubtags(
                                      //     languageCode: ConstantCodes
                                      //         .languageCodes[newValue] ??
                                      //         'en',
                                      //   ),
                                      // );
                                      Hive.box('settings')
                                          .put('language', newValue);
                                    },
                                  );
                                }
                              },
                              items: ConstantCodes.languageCodes.keys
                                  .map<DropdownMenuItem<String>>((language) {
                                return DropdownMenuItem<String>(
                                  value: language,
                                  child: Text(
                                    language,
                                    style: TextStyle(
                                      color: Theme.of(context).iconTheme.color,
                                        fontSize: 18),
                                  ),
                                );
                              }).toList(),
                            ),
                            dense: true,
                          ),
                          SizedBox(height: 2),
                          ListTile(
                            title: Text(
                              "Đội ngũ phát triển",
                              style: const TextStyle(fontSize: 20),
                            ),
                            leading: Iconify(
                              Mdi.information,
                              color: Colors.blue,
                            ),
                            contentPadding: EdgeInsets.zero,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title:
                                        Text('Đội ngũ phát triển của Vietime'),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('●  Thành viên:'),
                                        SizedBox(height: 4),
                                        Text('   ●  Huỳnh Tiến Dũng'),
                                        Text('   ●  Nguyễn Kim Quang Huy'),
                                        Text('   ●  Trương Minh Đức'),
                                        Text('   ●  Quách Lê Hải Anh'),
                                        SizedBox(height: 10),
                                        Text('●  Github: '),
                                        SizedBox(height: 4),
                                        SelectableText(
                                          '    https://github.com/HynDuf/vietime',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            dense: true,
                          ),
                          SizedBox(height: 3),
                          ListTile(
                            title: Text(
                              "Phiên bản",
                              style: const TextStyle(fontSize: 20),
                            ),
                            leading: Iconify(
                              Ph.list_numbers_fill,
                              color: Colors.red,
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "1.0.0",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
                            onTap: () {},
                            dense: true,
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: LongButton(
                      text: 'ĐĂNG XUẤT',
                      outerBoxColor: Color(0xffc43535),
                      innerBoxColor: Color(0xffe84040),
                      textColor: Colors.white,
                      onTap: () {
                        GetIt.I<APIHanlder>()
                            .storage
                            .delete(key: 'refresh_token');
                        GetIt.I<APIHanlder>().isLoggedIn.value = false;
                        Navigator.pop(context);
                      },
                    ),
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final Function onSave;
  CustomAppBar({required this.onSave});
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
              onSave();
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
