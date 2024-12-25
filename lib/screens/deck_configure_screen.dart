import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:vietime/entity/deck.dart';

import '../custom_widgets/error_dialog.dart';
import '../custom_widgets/snackbar.dart';
import '../helpers/api.dart';
import '../helpers/loader_dialog.dart';

class DeckConfigurePage extends StatefulWidget {
  final DeckWithCards deckData;
  DeckConfigurePage({required this.deckData});
  @override
  _DeckConfigurePageState createState() => _DeckConfigurePageState();
}

class _DeckConfigurePageState extends State<DeckConfigurePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    int maxNewCards = widget.deckData.deck.maxNewCards;
    int maxReviewCards = widget.deckData.deck.maxReviewCards;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt bộ thẻ'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextButton(
              onPressed: () {
                if (widget.deckData.deck.maxNewCards == maxNewCards &&
                    widget.deckData.deck.maxReviewCards == maxReviewCards) {
                  ShowSnackBar().showSnackBar(
                    context,
                    "Cài đặt mới sẽ có hiệu lực sau khi khởi động lại ứng dụng",
                    noAction: true,
                  );
                  return;
                }
                if (_formKey.currentState?.validate() ?? false) {
                  showLoaderDialog(context);
                  APIHelper.submitConfigureDeckRequest(
                          widget.deckData.deck.id, maxNewCards, maxReviewCards)
                      .then((configureDeckResponse) {
                    if (configureDeckResponse.containsKey("error")) {
                      Navigator.pop(context);
                      ErrorDialog.show(context);
                    } else {
                      widget.deckData.deck.maxNewCards = maxNewCards;
                      widget.deckData.deck.maxReviewCards = maxReviewCards;
                      ShowSnackBar().showSnackBar(
                        context,
                        "Cài đặt mới sẽ có hiệu lực sau khi khởi động lại ứng dụng",
                        noAction: true,
                      );
                      Navigator.pop(context);
                    }
                  });
                }
              },
              child: Text(
                'LƯU',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 19.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10.0),
          children: [
            buildNumberInput(
              'Số lượng tối đa thẻ mới được học mỗi ngày',
              'Loại thẻ xanh dương',
              maxNewCards,
              (value) {
                maxNewCards = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            buildNumberInput(
              'Số lượng tối đa thẻ ôn tập mỗi ngày',
              'Loại thẻ xanh lá cây',
              maxReviewCards,
              (value) {
                maxReviewCards = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile buildNumberInput(
    String title,
    String subtitle,
    int value,
    Function(int) onChanged,
  ) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '($subtitle)',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
      ),
      trailing: SizedBox(
        width: 70.0,
        child: TextFormField(
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.center,
          initialValue: value.toString(),
          keyboardType: TextInputType.number,
          onChanged: (newValue) {
            if (newValue.isEmpty) {
              value = 0;
            } else {
              value = int.tryParse(newValue) ?? 0;
            }
            if (value > 0) {
              onChanged(value);
            }
          },
          validator: (newValue) {
            if (newValue == null || newValue.isEmpty) {
              return 'Không thỏa';
            }
            if (int.tryParse(newValue) == null) {
              return 'Không thỏa';
            } else if (int.tryParse(newValue)! <= 0) {
              return "> 0";
            }
            return null;
          },
        ),
      ),
    );
  }
}
