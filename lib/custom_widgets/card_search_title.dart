import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../entity/deck.dart';
import '../helpers/validate.dart';
import 'animated_text.dart';
class CardSearchTile extends StatelessWidget {
  final Card itemCard;
  final Deck itemDeck;
  final Widget iconButtonTopRight;
  final Widget iconButtonBottomRight;

  CardSearchTile(
      {required this.itemCard,
        required this.itemDeck,
        required this.iconButtonBottomRight,
        required this.iconButtonTopRight});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Placeholder(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(30.0),
        ),
        margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        child: validateURL(itemDeck.descriptionImgPath)
                            ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          errorWidget: (context, _, __) => const Image(
                            fit: BoxFit.cover,
                            image:
                            AssetImage('assets/deck_placeholder.png'),
                          ),
                          imageUrl: itemDeck.descriptionImgPath,
                          placeholder: (context, url) => const Image(
                            fit: BoxFit.cover,
                            image:
                            AssetImage('assets/deck_placeholder.png'),
                          ),
                        )
                            : const Image(
                          fit: BoxFit.cover,
                          image:
                          AssetImage('assets/deck_placeholder.png'),
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
                            text: "Thẻ #7 - ${itemDeck.name}",
                            pauseAfterRound: const Duration(seconds: 3),
                            showFadingOnlyWhenScrolling: false,
                            startAfter: const Duration(seconds: 3),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                            ),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            defaultAlignment: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [iconButtonTopRight, iconButtonBottomRight],
              ),
            ),
          ],
        ),
      ),
    );
  }
}