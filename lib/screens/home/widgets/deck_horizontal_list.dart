import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../custom_widgets/custom_physics.dart';
import '../../../entity/deck.dart';

List<DeckWithReviewCards> decksList = [
  // Mock DeckWithReviewCards 1
  DeckWithReviewCards(
    deck: Deck(
        id: '1',
        isGlobal: false,
        name: 'Deck 1',
        description: 'Description for Deck 1',
        createdAt: DateTime.now(),
        userId: 'user1',
        descriptionImgPath:
            "https://static.vinwonders.com/production/hoang-thanh-thang-long-2.jpg"),
    cards: [], // Empty list of flashcards
  ),

  // Mock DeckWithReviewCards 2
  DeckWithReviewCards(
    deck: Deck(
        id: '2',
        isGlobal: true,
        name: 'Global Deck',
        description: 'Description for Global Deck',
        createdAt: DateTime.now(),
        userId: 'user2',
        descriptionImgPath:
            "https://ik.imagekit.io/tvlk/blog/2022/09/chua-mot-cot-1.jpg?tr=dpr-2,w-675"),
    cards: [], // Empty list of flashcards
  ),

  // Mock DeckWithReviewCards 3
  DeckWithReviewCards(
    deck: Deck(
      id: '3',
      isGlobal: false,
      name: 'Deck 3',
      description: 'Description for Deck 3',
      createdAt: DateTime.now(),
      userId: 'user3',
    ),
    cards: [], // Empty list of flashcards
  ),

  // Mock DeckWithReviewCards 4
  DeckWithReviewCards(
    deck: Deck(
      id: '4',
      isGlobal: true,
      name: 'Global Deck 2',
      description: 'Description for Global Deck 2',
      createdAt: DateTime.now(),
      userId: 'user4',
    ),
    cards: [], // Empty list of flashcards
  ),

  // Mock DeckWithReviewCards 5
  DeckWithReviewCards(
    deck: Deck(
      id: '5',
      isGlobal: false,
      name: 'Deck 5',
      description: 'Description for Deck 5',
      createdAt: DateTime.now(),
      userId: 'user5',
    ),
    cards: [], // Empty list of flashcards
  ),
];

class DeckHorizontalList extends StatelessWidget {
  final int itemCountPerGroup;

  DeckHorizontalList({this.itemCountPerGroup = 4});

  @override
  Widget build(BuildContext context) {
    final double portion = (decksList.length <= itemCountPerGroup) ? 1.0 : 0.8;
    final double listSize = MediaQuery.of(context).size.width * portion;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 4),
      child: SizedBox(
        height: decksList.length < itemCountPerGroup
            ? 110.0 * decksList.length
            : 110.0 * itemCountPerGroup,
        child: Align(
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            physics: PagingScrollPhysics(itemDimension: listSize),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemExtent: listSize,
            itemCount: (decksList.length / itemCountPerGroup).ceil(),
            itemBuilder: (context, index) {
              return SizedBox(
                width: listSize,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(itemCountPerGroup, (subIndex) {
                    final itemIndex = index * itemCountPerGroup + subIndex;
                    if (itemIndex < decksList.length) {
                      final item = decksList[itemIndex];
                      return GestureDetector(
                        onTap: () => {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[
                                100], // Add a slightly grey background color
                            borderRadius: BorderRadius.circular(
                                30.0), // Optional: Add rounded corners
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 7),
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
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    errorWidget: (context, _, __) =>
                                        const Image(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          'assets/deck_placeholder.png'),
                                    ),
                                    imageUrl: item.deck.descriptionImgPath,
                                    placeholder: (context, url) => Image(
                                      fit: BoxFit.fill,
                                      image: const AssetImage(
                                          'assets/deck_placeholder.png'),
                                    ),
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
                                    Text(
                                      item.deck.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            4.0), // Vertical space between title and subtitle
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '20',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                              WidgetSpan(
                                                child: SizedBox(
                                                    width:
                                                        6.0), // Adjust the width as needed for the space
                                              ),
                                              TextSpan(
                                                text: '18',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                              WidgetSpan(
                                                child: SizedBox(
                                                    width:
                                                        6.0), // Adjust the width as needed for the space
                                              ),
                                              TextSpan(
                                                text: '33',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          'Subtitle Line 2',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SizedBox(); // Return an empty widget if the index is out of bounds
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
