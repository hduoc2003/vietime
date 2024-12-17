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
import '../screens/deck_screen.dart';
import 'deck_list_info_bar.dart';
import 'deck_popup_menu.dart';

class DeckSearch extends SearchDelegate {
  final List<DeckWithReviewCards> data;

  DeckSearch({required this.data});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isEmpty)
        IconButton(
          icon: const Iconify(Ri.search_eye_line),
          tooltip: "Tìm kiêm",
          onPressed: () {},
        )
      else
        IconButton(
          onPressed: () {
            query = '';
          },
          tooltip: "Xóa",
          icon: const Icon(
            Icons.clear_rounded,
          ),
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      tooltip: "Quay lại",
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<DeckWithReviewCards> suggestionList;
    if (query.isEmpty) {
      suggestionList = data;
    } else {
      List<String> queryWords =
      removeDiacritics(query.toLowerCase()).split(RegExp(r'\s+'));

      List<DeckWithReviewCards> filteredData = [
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
            child: validateURL(suggestionList[index].deck.descriptionImgPath)
                ? CachedNetworkImage(
              fit: BoxFit.cover,
              errorWidget: (context, _, __) => const Image(
                fit: BoxFit.cover,
                image: AssetImage('assets/deck_placeholder.png'),
              ),
              imageUrl: suggestionList[index].deck.descriptionImgPath,
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
                color: Colors.black,
              ),
            ),
            Text(
              "${suggestionList[index].deck.rating.toStringAsFixed(1)}",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
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
                color: Colors.black,
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
            itemCount: suggestionList.length,
            itemBuilder: (context, index) {
              DeckWithReviewCards item = suggestionList[index];
              if (item.deck.isPublic) {
                return PublicDeckTile(
                    item: item,
                    iconButtonTopRight: DeckPopupMenu(
                      deckItem: item,
                      icon: const Iconify(Carbon.settings_adjust),
                    ),
                    iconButtonBottomRight: LoveDeckButton(deckItem: item));
              } else {
                return UserDeckTile(
                    item: item,
                    iconButtonTopRight: DeckPopupMenu(
                      deckItem: item,
                      icon: const Iconify(Carbon.settings_adjust),
                    ),
                    iconButtonBottomRight: LoveDeckButton(deckItem: item));
              }
            }),
      ],
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Theme.of(context).colorScheme.secondary,
      textSelectionTheme:
      const TextSelectionThemeData(cursorColor: Colors.black),
      hintColor: Colors.black54,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.black),
      textTheme: theme.textTheme.copyWith(
        titleLarge: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor:
        Colors.grey[200], // Set the background color of the rounded box
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none, // Remove the border for focused state
          borderRadius: BorderRadius.circular(
              50.0), // Set border radius for rounded corners
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none, // Remove the border for normal state
          borderRadius: BorderRadius.circular(
              50.0), // Set border radius for rounded corners
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
      ),
    );
  }
}