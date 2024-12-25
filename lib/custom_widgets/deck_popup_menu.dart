import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:vietime/custom_widgets/snackbar.dart';
import 'package:vietime/entity/deck.dart';
import 'package:vietime/screens/edit_deck_screen.dart';

import '../helpers/api.dart';
import '../helpers/loader_dialog.dart';
import '../screens/deck_configure_screen.dart';
import '../services/api_handler.dart';
import 'delete_confirm.dart';
import 'error_dialog.dart';

class UserDeckPopupMenu extends StatefulWidget {
  final DeckWithCards deckItem;
  final Iconify icon;
  final bool isPopSecond;
  const UserDeckPopupMenu(
      {super.key,
      required this.deckItem,
      required this.icon,
      this.isPopSecond = true});

  @override
  _UserDeckPopupMenuState createState() => _UserDeckPopupMenuState();
}

class _UserDeckPopupMenuState extends State<UserDeckPopupMenu> {
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
                Mdi.cards_playing_spade_multiple,
                size: 26,
                color: Theme.of(context).iconTheme.color,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Tham số",
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
          value: 2,
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
              builder: (context) =>
                  DeckConfigurePage(deckData: widget.deckItem),
            ),
          );
        }
        if (value == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditDeckScreen(deckData: widget.deckItem),
            ),
          );
        }

        if (value == 2) {
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
                      GetIt.I<APIHanlder>()
                          .onDeleteDeckSuccess(widget.deckItem.deck.id);
                      ShowSnackBar().showSnackBar(
                        context,
                        "Đã xóa bộ thẻ khỏi danh sách của bạn",
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

class PublicDeckPopupMenu extends StatefulWidget {
  final DeckWithCards deckItem;
  final Iconify icon;
  final bool isPopSecond;
  const PublicDeckPopupMenu(
      {super.key,
      required this.deckItem,
      required this.icon,
      this.isPopSecond = true});

  @override
  _PublicDeckPopupMenuState createState() => _PublicDeckPopupMenuState();
}

class _PublicDeckPopupMenuState extends State<PublicDeckPopupMenu> {
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
                Ic.baseline_file_download,
                size: 22,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10.0),
              Text("Lưu bộ thẻ"),
            ],
          ),
        ),
      ],
      onSelected: (int? value) {
        if (value == 0) {
          showLoaderDialog(context);
          APIHelper.submitCopyDeckRequest(widget.deckItem.deck.id)
              .then((copyDeckResponse) {
            if (copyDeckResponse.containsKey("error")) {
              Navigator.pop(context);
              ErrorDialog.show(context);
            } else {
              Navigator.of(context).popUntil((route) => route.isFirst);
              GetIt.I<APIHanlder>().onCopyDeckSuccess(copyDeckResponse);
              ShowSnackBar().showSnackBar(
                context,
                "Đã lưu bộ thẻ vào bộ thẻ cá nhân",
                noAction: true,
              );
            }
          });
        }
      },
    );
  }
}
