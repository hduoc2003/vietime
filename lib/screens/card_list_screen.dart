import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vietime/custom_widgets/card_tile.dart';

import '../entity/card.dart';
import '../services/api_handler.dart';
import 'create_card_screen.dart';

class CardsListScreen extends StatelessWidget {
  final String deckID;
  final bool isPublic;
  final List<Flashcard> flashcards;

  CardsListScreen(
      {required this.deckID,
      required this.isPublic,
      required this.flashcards}) {
    flashcards.sort((a, b) => a.index.compareTo(b.index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Danh sách thẻ'),
          actions: [
            isPublic
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateCardScreen(
                                      deckID: deckID,
                                    )));
                      },
                    ),
                  ),
          ],
        ),
        body: ValueListenableBuilder(
            valueListenable: isPublic
                ? GetIt.I<APIHanlder>().publicDecksChanged
                : GetIt.I<APIHanlder>().userDecksChanged,
            builder: (
              BuildContext context,
              bool value,
              Widget? child,
            ) {
              return ListView.builder(
                itemCount: flashcards.length,
                itemBuilder: (context, index) {
                  return CardTile(flashcard: flashcards[index]);
                },
              );
            }));
  }
}
