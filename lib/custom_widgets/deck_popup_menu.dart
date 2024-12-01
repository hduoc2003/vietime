import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:vietime/entity/deck.dart';

class DeckPopupMenu extends StatefulWidget {
  final DeckWithReviewCards deckItem;
  const DeckPopupMenu({
    super.key,
    required this.deckItem,
  });

  @override
  _DeckPopupMenuState createState() => _DeckPopupMenuState();
}

class _DeckPopupMenuState extends State<DeckPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Iconify(Carbon.settings_adjust),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Iconify(
                Ri.settings_4_fill,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10.0),
              Text("Cài đặt"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Iconify(
                Ri.delete_bin_2_fill,
                size: 20,
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
          // TODO:
        }
      },
    );
  }
}