import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:vietime/custom_widgets/deck_list_info_bar.dart';
import 'package:vietime/custom_widgets/deck_search.dart';

import '../custom_widgets/deck_list_tile.dart';
import '../custom_widgets/deck_popup_menu.dart';
import '../custom_widgets/love_button.dart';
import '../entity/deck.dart';
import '../services/api_handler.dart';

class DeckListScreen extends StatelessWidget {
  final bool isPublic;
  final List<DeckWithCards> decksList;

  DeckListScreen({required this.decksList, required this.isPublic});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: isPublic ? Text('Bộ thẻ công khai') : Text('Bộ thẻ của bạn'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Iconify(Ri.search_eye_line),
              tooltip: "Tìm kiếm",
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DeckSearch(data: decksList),
                );
              },
            )
          ],
        ),
        body: ValueListenableBuilder(
            valueListenable: isPublic
                ? GetIt.I<APIHanlder>().publicDecksChanged
                : GetIt.I<APIHanlder>().userDecksChanged,
            builder: (
              BuildContext context,
              bool hidden,
              Widget? child,
            ) {
              return Column(
                children: [
                  DeckListInfoBar(
                    numberOfDecks: decksList.length,
                    onAddPressed: () {
                      // Add button pressed
                    },
                    onFilterPressed: () {
                      // Filter button pressed
                    },
                    onStudyAllPressed: () {
                      // Study All button pressed
                    },
                  ),
                  ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      shrinkWrap: true,
                      itemCount: decksList.length,
                      itemBuilder: (context, index) {
                        DeckWithCards item = decksList[index];
                        if (item.deck.isPublic) {
                          return PublicDeckTile(
                              item: item,
                              iconButtonTopRight: DeckPopupMenu(
                                deckItem: item,
                                icon: const Iconify(Carbon.settings_adjust),
                              ),
                              iconButtonBottomRight:
                                  LoveDeckButton(deckItem: item));
                        } else {
                          return UserDeckTile(
                              item: item,
                              iconButtonTopRight: DeckPopupMenu(
                                deckItem: item,
                                icon: const Iconify(Carbon.settings_adjust),
                              ),
                              iconButtonBottomRight:
                                  LoveDeckButton(deckItem: item));
                        }
                      }),
                ],
              );
            }));
  }
}
