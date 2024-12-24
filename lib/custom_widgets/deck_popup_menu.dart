import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:vietime/custom_widgets/snackbar.dart';
import 'package:vietime/entity/deck.dart';

import '../helpers/api.dart';
import '../helpers/loader_dialog.dart';
import '../services/api_handler.dart';
import 'delete_confirm.dart';
import 'error_dialog.dart';

class DeckPopupMenu extends StatefulWidget {
  final DeckWithCards deckItem;
  final Iconify icon;
  const DeckPopupMenu({
    super.key,
    required this.deckItem,
    required this.icon,
  });

  @override
  _DeckPopupMenuState createState() => _DeckPopupMenuState();
}

class _DeckPopupMenuState extends State<DeckPopupMenu> {
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
            children: [
              Iconify(
                Mdi.cards_playing_spade_multiple,
                size: 22,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10.0),
              Text("Tham số"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Iconify(
                Ri.delete_bin_2_fill,
                size: 22,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10.0),
              Text("Xóa"),
            ],
          ),
        ),
      ],
      onSelected: (int? value) {
        if (value == 0) {
          // TODO:
        }
        if (value == 1) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DeleteConfirmationDialog(
                onConfirm: () {
                  showLoaderDialog(context);
                  APIHelper.submitDeleteDeckRequest(widget.deckItem.deck.id)
                      .then((deleteDeckResponse) {
                    if (deleteDeckResponse.containsKey("error")) {
                      Navigator.pop(context);
                      ErrorDialog.show(context);
                    } else {
                      GetIt.I<APIHanlder>().onDeleteDeckSuccess(widget.deckItem.deck.id);
                      ShowSnackBar().showSnackBar(
                        context,
                        "Đã xóa bộ thẻ khỏi danh sách của bạn",
                      );
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
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
