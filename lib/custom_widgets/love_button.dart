import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:vietime/custom_widgets/snackbar.dart';
import 'package:vietime/entity/deck.dart';

import '../helpers/api.dart';
import '../services/api_handler.dart';

class LoveDeckButton extends StatefulWidget {
  final DeckWithCards deckItem;
  final double? size;
  final bool showSnack;
  const LoveDeckButton({
    super.key,
    required this.deckItem,
    this.size,
    this.showSnack = false,
  });

  @override
  _LoveDeckButtonState createState() => _LoveDeckButtonState();
}

class _LoveDeckButtonState extends State<LoveDeckButton>
    with SingleTickerProviderStateMixin {
  bool liked = false;
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _curve;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _curve = CurvedAnimation(parent: _controller, curve: Curves.slowMiddle);

    _scale = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(_curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    liked = widget.deckItem.deck.isFavorite;

    return ScaleTransition(
      scale: _scale,
      child: IconButton(
        icon: Icon(
          liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: liked ? Colors.redAccent : Theme.of(context).iconTheme.color,
        ),
        iconSize: widget.size ?? 24.0,
        tooltip: liked ? "Bỏ thích" : "Thích",
        onPressed: () async {
          widget.deckItem.deck.isFavorite ^= true;

          if (!liked) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
          widget.deckItem.deck.isFavorite = !liked;
          if (widget.deckItem.deck.isPublic) {
            List<String> favoritePublicDecks = Hive.box('settings')
                .get('favoritePublicDecks', defaultValue: []).cast<String>();
            if (!liked) {
              favoritePublicDecks.add(widget.deckItem.deck.id);
            } else {
              favoritePublicDecks.remove(widget.deckItem.deck.id);
            }
            Hive.box('settings')
                .put('favoritePublicDecks', favoritePublicDecks);
            GetIt.I<APIHanlder>().publicDecksChanged.value ^= true;
          } else {
            APIHelper.submitFavoriteDeckRequest(widget.deckItem.deck.id, !liked)
                .then((likeDeckResponse) {
              if (likeDeckResponse.containsKey("error")) {
                // TODO: Retry or something
              }
            });
          }
          setState(() {
            liked = !liked;
          });
          if (widget.showSnack) {
            ShowSnackBar().showSnackBar(
              context,
              liked ? "Đã thêm vào mục Yêu thích" : "Đã xóa khỏi mục Yêu thích",
              duration: Duration(milliseconds: 2200),
              noAction: true,
            );
          }
        },
      ),
    );
  }
}
