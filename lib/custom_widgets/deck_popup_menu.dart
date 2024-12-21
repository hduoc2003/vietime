import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:vietime/entity/deck.dart';

class DeckPopupMenu extends StatefulWidget {
  final DeckWithReviewCards deckItem;
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
          // TODO:
        }
      },
    );
  }
}
