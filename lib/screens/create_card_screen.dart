import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../custom_widgets/error_dialog.dart';
import '../custom_widgets/long_button.dart';
import '../custom_widgets/snackbar.dart';
import '../helpers/api.dart';
import '../helpers/loader_dialog.dart';
import '../services/api_handler.dart';

class CreateCardScreen extends StatefulWidget {
  final String deckID;
  CreateCardScreen({required this.deckID});
  @override
  _CreateCardScreenState createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends State<CreateCardScreen> {
  TextEditingController questionController = TextEditingController();
  TextEditingController correctAnswerController = TextEditingController();
  TextEditingController wrongAnswer1Controller = TextEditingController();
  TextEditingController wrongAnswer2Controller = TextEditingController();
  TextEditingController wrongAnswer3Controller = TextEditingController();
  TextEditingController questionImgURLController = TextEditingController();
  TextEditingController questionImgLabelController = TextEditingController();

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo thẻ mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFieldWithTitle('Câu hỏi:', questionController, 4),
              _buildTextFieldWithTitle(
                  'Câu trả lời đúng:', correctAnswerController, 3),
              _buildTextFieldWithTitle(
                  'Câu trả lời sai 1:', wrongAnswer1Controller, 2),
              _buildTextFieldWithTitle(
                  'Câu trả lời sai 2:', wrongAnswer2Controller, 2),
              _buildTextFieldWithTitle(
                  'Câu trả lời sai 3:', wrongAnswer3Controller, 2),
              _buildTextFieldWithTitle(
                  'Đường dẫn của hình minh họa:', questionImgURLController, 2),
              _buildTextFieldWithTitle(
                  'Mô tả của hình minh họa:', questionImgLabelController, 2),
              errorMessage.isNotEmpty
                  ? Text(
                      errorMessage,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    )
                  : SizedBox(),
              SizedBox(height: 15),
              LongButton(
                text: 'TẠO THẺ',
                outerBoxColor: Color(0xff1783d1),
                innerBoxColor: Color(0xff46a4e8),
                textColor: Colors.white,
                onTap: () {
                  errorMessage = "";
                  if (_validateInputs()) {
                    showLoaderDialog(context);
                    APIHelper.submitCreateCardRequest(
                            widget.deckID,
                            questionController.text,
                            correctAnswerController.text,
                            [
                              wrongAnswer1Controller.text,
                              wrongAnswer2Controller.text,
                              wrongAnswer3Controller.text,
                            ],
                            questionImgURLController.text,
                            questionImgLabelController.text)
                        .then((createCardResponse) {
                      if (createCardResponse.containsKey("error")) {
                        Navigator.pop(context);
                        ErrorDialog.show(context);
                      } else {
                        GetIt.I<APIHanlder>().onCreateCardSuccess(
                            widget.deckID, createCardResponse);
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

    if (questionController.text.isEmpty) {
      errorMessage = 'Lỗi: Vui lòng nhập câu hỏi.';
      return false;
    }

    if (correctAnswerController.text.isEmpty ||
        wrongAnswer1Controller.text.isEmpty ||
        wrongAnswer2Controller.text.isEmpty ||
        wrongAnswer3Controller.text.isEmpty) {
      errorMessage = 'Lỗi: Vui lòng nhập đầy đủ câu trả lời đúng và sai.';
      return false;
    }

    return true;
  }
}
