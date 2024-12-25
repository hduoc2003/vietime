import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vietime/entity/deck.dart';
import '../custom_widgets/error_dialog.dart';
import '../custom_widgets/snackbar.dart';
import '../helpers/api.dart';
import '../helpers/loader_dialog.dart';
import '../services/api_handler.dart';

class EditDeckScreen extends StatefulWidget {
  final DeckWithCards deckData;
  EditDeckScreen({required this.deckData});

  @override
  _EditDeckScreenState createState() => _EditDeckScreenState();
}

class _EditDeckScreenState extends State<EditDeckScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController descriptionImgURLController = TextEditingController();

  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    nameController.text = widget.deckData.deck.name;
    descriptionController.text = widget.deckData.deck.description;
    descriptionImgURLController.text = widget.deckData.deck.descriptionImgURL;
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa bộ thẻ'),
        actions: [
          TextButton(
            onPressed: () {
              errorMessage = "";
              if (_validateInputs()) {
                showLoaderDialog(context);
                APIHelper.submitEditDeckRequest(
                  widget.deckData.deck.id,
                  nameController.text,
                  descriptionController.text,
                  descriptionImgURLController.text,
                ).then((editDeckResponse) {
                  if (editDeckResponse.containsKey("error")) {
                    Navigator.pop(context);
                    ErrorDialog.show(context);
                  } else {
                    GetIt.I<APIHanlder>().onEditDeckSuccess(editDeckResponse);
                    ShowSnackBar().showSnackBar(
                      context,
                      "Bộ thẻ đã được cập nhật",
                      noAction: true,
                    );
                    Navigator.pop(context);
                  }
                });
              } else {
                setState(() {});
              }
            },
            child: Text(
              'LƯU',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              _buildTextFieldWithTitle('Tên bộ thẻ:', nameController, 4),
              _buildTextFieldWithTitle('Mô tả:', descriptionController, 3),
              _buildTextFieldWithTitle(
                  'Đường dẫn hình ảnh mô tả:', descriptionImgURLController, 2),
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
