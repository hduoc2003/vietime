import 'package:cached_network_image/cached_network_image.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:vietime/custom_widgets/deck_list_tile.dart';
import 'package:vietime/custom_widgets/love_button.dart';
import 'package:vietime/custom_widgets/three_card_type_number_row.dart';
import 'package:vietime/helpers/string.dart';

import '../entity/deck.dart';
import '../helpers/validate.dart';
import '../screens/create_deck_screen.dart';
import '../screens/deck_screen.dart';
import '../services/theme_manager.dart';
import 'deck_list_info_bar.dart';
import 'deck_popup_menu.dart';

class DeckSearch extends SearchDelegate {
  final List<DeckWithCards> data;

  DeckSearch({required this.data});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isEmpty)
        IconButton(
          icon: Iconify(
            Ri.search_eye_line,
            color: Theme.of(context).iconTheme.color,
          ),
          tooltip: "Tìm kiêm",
          onPressed: () {},
        )
      else
        IconButton(
          onPressed: () {
            query = '';
          },
          tooltip: "Xóa",
          icon: Icon(
            Icons.clear_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_rounded,
        color: Theme.of(context).iconTheme.color,
      ),
      tooltip: "Quay lại",
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<DeckWithCards> suggestionList;
    if (query.isEmpty) {
      suggestionList = data;
    } else {
      List<String> queryWords =
          removeDiacritics(query.toLowerCase()).split(RegExp(r'\s+'));

      List<DeckWithCards> filteredData = [
        ...data.where((element) {
          String rawName = removeDiacritics(element.deck.name.toLowerCase());
          String rawDes =
              removeDiacritics(element.deck.description.toLowerCase());
          return queryWords.any((queryWord) =>
              rawName.contains(queryWord) || rawDes.contains(queryWord));
        }),
      ];
      filteredData.sort((a, b) {
        String rawNameA =
            removeDiacritics(a.deck.name.toString().toLowerCase());
        String rawDesA =
            removeDiacritics(a.deck.description.toString().toLowerCase());
        String rawNameB =
            removeDiacritics(b.deck.name.toString().toLowerCase());
        String rawDesB =
            removeDiacritics(b.deck.description.toString().toLowerCase());
        int countMatchWordsA = countMatchWords(rawNameA, queryWords) +
            countMatchWords(rawDesA, queryWords);
        int countMatchWordsB = countMatchWords(rawNameB, queryWords) +
            countMatchWords(rawDesB, queryWords);
        return countMatchWordsB.compareTo(countMatchWordsA);
      });
      suggestionList = filteredData;
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      shrinkWrap: true,
      itemExtent: 70.0,
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        leading: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox.square(
            dimension: 50,
            child: validateURL(suggestionList[index].deck.descriptionImgURL)
                ? CachedNetworkImage(
                    fit: BoxFit.cover,
                    errorWidget: (context, _, __) => const Image(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/deck_placeholder.png'),
                    ),
                    imageUrl: suggestionList[index].deck.descriptionImgURL,
                    placeholder: (context, url) => const Image(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/deck_placeholder.png'),
                    ),
                  )
                : const Image(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/deck_placeholder.png'),
                  ),
          ),
        ),
        title: Text(
          suggestionList[index].deck.name,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: suggestionList[index].deck.isPublic
            ? Row(
                children: [
                  Text(
                    "Đánh giá: ",
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    "${suggestionList[index].deck.rating.toStringAsFixed(1)}",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 2),
                    child: Icon(
                      Icons.star,
                      color: Color(0xffedc202),
                      size: 18.0,
                    ),
                  ),
                  Text(
                    " ~ ${suggestionList[index].deck.views}",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 2),
                    child: Iconify(
                      Ion.ios_eye,
                      color: Colors.green,
                      size: 18.0,
                    ),
                  ),
                ],
              )
            : ThreeCardTypeNumbersRow(
                numBlueCards: suggestionList[index].numBlueCards,
                numRedCards: suggestionList[index].numRedCards,
                numGreenCards: suggestionList[index].numGreenCards,
                fontSize: 14,
                boxSize: 4,
              ),
        trailing: LoveDeckButton(
          deckItem: suggestionList[index],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeckScreen(deckData: suggestionList[index]),
            ),
          );
        },
      ),
    );
  }

  @override
  String get searchFieldLabel => 'Tìm kiếm';

  @override
  Widget buildResults(BuildContext context) {
    final List suggestionList;
    if (query.isEmpty) {
      suggestionList = data;
    } else {
      List<String> queryWords =
          removeDiacritics(query.toLowerCase()).split(RegExp(r'\s+'));

      List filteredData = [
        ...data.where((element) {
          String rawName = removeDiacritics(element.deck.name.toLowerCase());
          String rawDes =
              removeDiacritics(element.deck.description.toLowerCase());
          return queryWords.any((queryWord) =>
              rawName.contains(queryWord) || rawDes.contains(queryWord));
        }),
      ];
      filteredData.sort((a, b) {
        String rawNameA =
            removeDiacritics(a.deck.name.toString().toLowerCase());
        String rawDesA =
            removeDiacritics(a.deck.description.toString().toLowerCase());
        String rawNameB =
            removeDiacritics(b.deck.name.toString().toLowerCase());
        String rawDesB =
            removeDiacritics(b.deck.description.toString().toLowerCase());
        int countMatchWordsA = countMatchWords(rawNameA, queryWords) +
            countMatchWords(rawDesA, queryWords);
        int countMatchWordsB = countMatchWords(rawNameB, queryWords) +
            countMatchWords(rawDesB, queryWords);
        return countMatchWordsB.compareTo(countMatchWordsA);
      });
      suggestionList = filteredData;
    }
    return Column(
      children: [
        DeckListInfoBar(
          numberOfDecks: suggestionList.length,
          onAddPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateDeckScreen()),
            );
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
            itemCount: suggestionList.length,
            itemBuilder: (context, index) {
              DeckWithCards item = suggestionList[index];
              if (item.deck.isPublic) {
                return PublicDeckTile(
                    item: item,
                    iconButtonTopRight: PublicDeckPopupMenu(
                      deckItem: item,
                      icon: Iconify(
                        Carbon.settings_adjust,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    iconButtonBottomRight: LoveDeckButton(deckItem: item));
              } else {
                return UserDeckTile(
                    item: item,
                    iconButtonTopRight: UserDeckPopupMenu(
                      deckItem: item,
                      icon: Iconify(
                        Carbon.settings_adjust,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    iconButtonBottomRight: LoveDeckButton(deckItem: item));
              }
            }),
      ],
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      textTheme: theme.textTheme.copyWith(
        titleLarge:
            const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: myColors.deckTileBackground,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(50.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(50.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
      ),
    );
  }
}
