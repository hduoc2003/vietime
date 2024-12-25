import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../custom_widgets/error_dialog.dart';
import '../custom_widgets/long_button.dart';
import '../custom_widgets/snackbar.dart';
import '../helpers/api.dart';
import '../helpers/loader_dialog.dart';
import '../services/api_handler.dart';

class CreateDeckScreen extends StatefulWidget {
  CreateDeckScreen();
  @override
  _CreateDeckScreenState createState() => _CreateDeckScreenState();
}

class _CreateDeckScreenState extends State<CreateDeckScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController descriptionImgURLController = TextEditingController();

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo bộ thẻ mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFieldWithTitle('Tên bộ thẻ:', nameController, 4),
              _buildTextFieldWithTitle('Mô tả:', descriptionController, 3),
              _buildTextFieldWithTitle(
                  'Đường dẫn hình ảnh mô tả:', descriptionImgURLController, 2),
              errorMessage.isNotEmpty
                  ? Text(
                      errorMessage,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    )
                  : SizedBox(),
              SizedBox(height: 190),
              LongButton(
                text: 'TẠO BỘ THẺ',
                outerBoxColor: Color(0xff1783d1),
                innerBoxColor: Color(0xff46a4e8),
                textColor: Colors.white,
                onTap: () {
                  errorMessage = "";
                  if (_validateInputs()) {
                    showLoaderDialog(context);
                    APIHelper.submitCreateDeckRequest(
                      nameController.text,
                      descriptionController.text,
                      descriptionImgURLController.text,
                    ).then((createDeckResponse) {
                      if (createDeckResponse.containsKey("error")) {
                        Navigator.pop(context);
                        ErrorDialog.show(context);
                      } else {
                        GetIt.I<APIHanlder>()
                            .onCreateDeckSuccess(createDeckResponse);
                        ShowSnackBar().showSnackBar(
                          context,
                          "Đã thêm thẻ mới vào bộ",
                          noAction: true,
                        );
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    });
                  } else {
                    setState(() {});
                  }
                },
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithTitle(
      String title, TextEditingController controller, int maxLines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            style: TextStyle(fontSize: 17),
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Nhập ${title.substring(0, title.length - 1)} ở đây',
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: InputBorder.none,
            ),
            maxLines: maxLines,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  bool _validateInputs() {
    errorMessage = '';

    if (nameController.text.isEmpty) {
      errorMessage = 'Lỗi: Vui lòng nhập tên của bộ thẻ.';
      return false;
    }

    return true;
  }
}
