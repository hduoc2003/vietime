import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:vietime/custom_widgets/long_button.dart';
import '../../custom_widgets/editable_text_area.dart';
import '../../helpers/country_code.dart';
import '../../services/api_handler.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Box settingsBox = Hive.box('settings');
  String lang =
      Hive.box('settings').get('language', defaultValue: 'Vietnam') as String;
  bool isDarkMode =
      Hive.box('settings').get('darkMode', defaultValue: false) as bool;

  TextEditingController textArea1Controller =
      TextEditingController(text: "HynDuf");
  TextEditingController textArea2Controller =
      TextEditingController(text: "hynduf@gmail.com");
  TextEditingController textArea3Controller =
      TextEditingController(text: "........");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    children: [
                      Padding(
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
                                leading: Iconify(Ion.language),
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
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                dense: true,
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: 100,
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
            onPressed: () {},
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
