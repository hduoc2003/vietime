import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:vietime/custom_widgets/rounded_box_with_text.dart';
import 'package:vietime/custom_widgets/three_card_type_number_row.dart';
import 'package:vietime/helpers/validate.dart';

import '../../../custom_widgets/animated_progress_bar.dart';
import '../../../custom_widgets/animated_text.dart';
import '../../../custom_widgets/custom_physics.dart';
import '../../../entity/deck.dart';
import '../../../services/api_handler.dart';
import '../../deck_screen.dart';

class DeckHorizontalList extends StatelessWidget {
  final int itemCountPerGroup;
  final int deckType;
  final List<DeckWithCards> decksList;

  DeckHorizontalList(
      {this.itemCountPerGroup = 4,
      required this.deckType,
      required this.decksList});

  @override
  Widget build(BuildContext context) {
    final double portion =
        (decksList.length <= itemCountPerGroup) ? 0.96 : 0.84;
    final double listSize = MediaQuery.of(context).size.width * portion;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 4),
      child: SizedBox(
        height: 110.0 * itemCountPerGroup,
        child: Align(
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            physics: PagingScrollPhysics(itemDimension: listSize),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemExtent: listSize,
            itemCount: max(1, (decksList.length / itemCountPerGroup).ceil()),
            itemBuilder: (context, index) {
              return SizedBox(
                width: listSize,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(itemCountPerGroup, (subIndex) {
                    final itemIndex = index * itemCountPerGroup + subIndex;
                    if (itemIndex < decksList.length) {
                      final item = decksList[itemIndex];
                      if (deckType == 0) {
                        return getUserDeckTile(item, context);
                      } else {
                        return getPublicDeckTile(item, context);
                      }
                    } else if (decksList.length < 3) {
                      return RoundedBoxWithText();
                    } else {
                      return const SizedBox(); // Return an empty widget if the index is out of bounds
                    }
                  }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget getUserDeckTile(DeckWithCards item, BuildContext context) {
  return ValueListenableBuilder(
      valueListenable: GetIt.I<APIHanlder>().userDecksChanged,
      builder: (
        BuildContext context,
        bool hidden,
        Widget? child,
      ) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeckScreen(deckData: item),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100], // Add a slightly grey background color
              borderRadius:
                  BorderRadius.circular(30.0), // Optional: Add rounded corners
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Leading Section
              Card(
                margin: EdgeInsets.zero,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  width: 75,
                  height: 75,
                  child: validateURL(item.deck.descriptionImgURL)
                      ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          errorWidget: (context, _, __) => const Image(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/deck_placeholder.png'),
                          ),
                          imageUrl: item.deck.descriptionImgURL,
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

              // Padding between leading and title/subtitle
              const SizedBox(width: 16.0),

              // Title and Subtitle Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedText(
                      text: item.deck.name,
                      pauseAfterRound: const Duration(
                        seconds: 3,
                      ),
                      showFadingOnlyWhenScrolling: false,
                      startAfter: const Duration(
                        seconds: 3,
                      ),
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 17),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      defaultAlignment: TextAlign.start,
                    ),
                    const SizedBox(height: 4.0),
                    ThreeCardTypeNumbersRow(
                        numBlueCards: item.numBlueCards,
                        numRedCards: item.numRedCards,
                        numGreenCards: item.numGreenCards),
                    SizedBox(height: 4.0),
                    (item.deck.totalCards == 0)
                        ? const Text(
                            'Chưa có thẻ nào',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        : Row(
                            children: [
                              AnimatedProgressBar(
                                width: 150,
                                height: 14,
                                progress: item.deck.totalLearnedCards /
                                    item.deck.totalCards,
                                backgroundColor: const Color(0xffD9D9D9),
                                progressColor: const Color(0xff40a5e8),
                                innerProgressColor: const Color(0xff6db7f4),
                              ),
                              SizedBox(width: 16.0),
                              Text(
                                '${(item.deck.totalLearnedCards / item.deck.totalCards * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ]),
          ),
        );
      });
}

Widget getPublicDeckTile(DeckWithCards item, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeckScreen(deckData: item),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[100], // Add a slightly grey background color
        borderRadius:
            BorderRadius.circular(30.0), // Optional: Add rounded corners
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Leading Section
        Card(
          margin: EdgeInsets.zero,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: 75,
            height: 75,
            child: validateURL(item.deck.descriptionImgURL)
                ? CachedNetworkImage(
                    fit: BoxFit.cover,
                    errorWidget: (context, _, __) => const Image(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/deck_placeholder.png'),
                    ),
                    imageUrl: item.deck.descriptionImgURL,
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

        // Padding between leading and title/subtitle
        SizedBox(width: 16.0),

        // Title and Subtitle Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedText(
                text: item.deck.name,
                pauseAfterRound: const Duration(
                  seconds: 3,
                ),
                showFadingOnlyWhenScrolling: false,
                startAfter: const Duration(
                  seconds: 3,
                ),
                style:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                crossAxisAlignment: CrossAxisAlignment.start,
                defaultAlignment: TextAlign.start,
              ),
              SizedBox(height: 4.0),
              Row(
                children: [
                  Text(
                    "Số lượng: ",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${item.deck.totalCards}",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w900),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, bottom: 2),
                    child: Iconify(
                      Mdi.cards_playing,
                      color: Colors.purple,
                      size: 20.0, // Adjust the size as needed
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8.0), // Add some space between the two texts
              Row(
                children: [
                  Text(
                    "Đánh giá: ",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${item.deck.rating.toStringAsFixed(1)}",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w900),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, bottom: 2),
                    child: Icon(
                      Icons.star,
                      color: Color(0xffedc202),
                      size: 20.0, // Adjust the size as needed
                    ),
                  ),
                  Text(
                    " ~ ${item.deck.views}",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w900),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, bottom: 2),
                    child: Iconify(
                      Ion.ios_eye,
                      color: Colors.green,
                      size: 20.0, // Adjust the size as needed
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    ),
  );
}
