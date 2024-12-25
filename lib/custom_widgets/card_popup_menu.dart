import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:vietime/custom_widgets/snackbar.dart';
import 'package:vietime/entity/card.dart';

import '../entity/deck.dart';
import '../helpers/api.dart';
import '../helpers/loader_dialog.dart';
import '../screens/edit_card_screen.dart';
import '../services/api_handler.dart';
import 'delete_confirm.dart';
import 'error_dialog.dart';

class UserCardPopupMenu extends StatefulWidget {
  final Flashcard card;
  final Iconify icon;
  final bool isPopSecond;
  const UserCardPopupMenu(
      {super.key,
      required this.card,
      required this.icon,
      this.isPopSecond = true});

  @override
  _UserCardPopupMenuState createState() => _UserCardPopupMenuState();
}

class _UserCardPopupMenuState extends State<UserCardPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: widget.icon,
      position: PopupMenuPosition.under,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Iconify(
                Ic.baseline_mode_edit,
                size: 26,
                color: Theme.of(context).iconTheme.color,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Chỉnh sửa",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Iconify(
                Ri.delete_bin_2_fill,
                size: 26,
                color: Colors.red,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Xóa",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (int? value) {
        if (value == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditCardScreen(
                deckID: widget.card.deckId,
                card: widget.card,
              ),
            ),
          );
        }
        if (value == 1) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DeleteConfirmationDialog(
                onConfirm: () {
                  showLoaderDialog(context);
                  APIHelper.submitDeleteCardRequest(widget.card.id)
                      .then((deleteCardResponse) {
                    if (deleteCardResponse.containsKey("error")) {
                      Navigator.pop(context);
                      ErrorDialog.show(context);
                    } else {
                      GetIt.I<APIHanlder>().onDeleteCardSuccess(widget.card);
                      ShowSnackBar().showSnackBar(
                        context,
                        "Đã xóa thẻ khỏi bộ thẻ",
                        noAction: true,
                      );
                      Navigator.pop(context);
                      if (widget.isPopSecond) {
                        Navigator.pop(context);
                      }
                    }
                    Navigator.pop(context);
                  });
                },
              );
            },
          );
        }
      },
    );
  }
}
