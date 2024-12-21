import 'dart:math';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:logging/logging.dart';
import 'package:vietime/custom_widgets/card_search_tile.dart';
import 'package:vietime/custom_widgets/deck_list_tile.dart';
import 'package:vietime/custom_widgets/search_filter.dart';
import 'package:vietime/custom_widgets/search_info_bar.dart';
import 'package:vietime/entity/deck.dart';
import 'package:vietime/entity/search.dart';
import 'package:vietime/services/api_handler.dart';
import 'package:vietime/services/mock_data.dart';

import '../custom_widgets/empty_screen.dart';
import '../custom_widgets/search_bar.dart';
import '../entity/card.dart';
import '../helpers/string.dart';

class SearchPage extends StatefulWidget {
  final String query;
  final bool autofocus;
  const SearchPage({
    super.key,
    required this.query,
    this.autofocus = false,
  });
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  bool status = false;
  List<SearchResult> searchedList = [];
  bool fetched = false;
  bool done = true;
  final ValueNotifier<List<String>> searchHistory = ValueNotifier<List<String>>(
      Hive.box('settings')
          .get('searchHistory', defaultValue: []).cast<String>());
  final ValueNotifier<bool> changeFilter = ValueNotifier<bool>(false);
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool haveText = false;
  bool userDeckFilter = true;
  bool publicDeckFilter = true;
  bool cardFilter = true;

  @override
  void initState() {
    _controller.text = widget.query;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<SearchResult>> getSearchResults(String query) async {
    Logger.root.info('Getting search results...');
    final List<DeckWithReviewCards> decksList = mockDecksList;
    final List<Flashcard> cardsList = mockQuestions;
    final List<SearchResult> results = [];
    List<String> queryWords =
        removeDiacritics(query.toLowerCase()).split(RegExp(r'\s+'));
    for (DeckWithReviewCards d in decksList) {
      String rawName = removeDiacritics(d.deck.name.toString().toLowerCase());
      String rawDes =
          removeDiacritics(d.deck.description.toString().toLowerCase());
      int score = 2 * countMatchWords(rawName, queryWords) +
          countMatchWords(rawDes, queryWords);
      if (score == 0) {
        continue;
      }
      results.add(SearchResult(
          d.deck.isPublic
              ? ResultType.publicDeckResult
              : ResultType.userDeckResult,
          score,
          d));
    }
    for (Flashcard f in cardsList) {
      String rawContent = "${f.question} ${f.answers.join(" ")}";
      String content =
          removePunctuation(removeDiacritics(rawContent.toLowerCase()));
      int score = countMatchWords(content, queryWords);
      Logger.root.info(content);
      Logger.root.info(score);
      if (score == 0) {
        continue;
      }
      Logger.root.info("OK");
      List<TextSpan> bestTextSpans = [];
      List<String> rawWords = rawContent.split(' ');
      List<String> words = content.split(' ');
      if (words.length != rawWords.length) {
        Logger.root.severe(
            "Raw words length != words length! Something wrong about punctuations");
      }
      int maxSegScore = 0;
      for (int st = 0; st < words.length; ++st) {
        int segScore = 0;
        List<TextSpan> textSpans = [];
        textSpans.add(
          const TextSpan(
            text: "...",
          ),
        );
        for (int i = st; i < words.length; ++i) {
          String word = words[i];
          int cnt = countMatchWords(word, queryWords);
          int boldness = 0;
          if (cnt > 0) {
            boldness = 1;
            for (String q in queryWords) {
              if (word == q) {
                boldness = 2;
                break;
              }
            }
          }
          textSpans.add(TextSpan(
              text: "${rawWords[i]} ",
              style: TextStyle(
                fontWeight: (boldness == 2
                    ? FontWeight.w900
                    : (boldness == 1 ? FontWeight.w600 : FontWeight.normal)),
              )));
          segScore += boldness;
        }
        if (maxSegScore < segScore) {
          maxSegScore = segScore;
          bestTextSpans = textSpans;
        }
        if (st + 20 >= words.length) {
          break;
        }
      }
      results.add(SearchResult(
          ResultType.cardResult,
          score,
          FlashcardSearch(
              f,
              RichText(
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: bestTextSpans,
                ),
              ))));
    }
    results.sort((a, b) => b.score.compareTo(a.score));
    return results;
  }

  Future<List<String>> getSearchSuggestions(String query) async {
    if (query == '') {
      return [];
    }
    final List<String> results = await GetIt.I<APIHanlder>()
        .googleSearchSuggestions
        .fetchSuggestions(query);
    return results;
  }

  @override
  Widget build(BuildContext context) {
    double circleProgressSize = min(250, MediaQuery.of(context).size.width / 2);
    if (!status) {
      status = true;
      if (query.isEmpty && widget.query.isEmpty) {
        fetched = true;
      } else {
        getSearchResults(query == '' ? widget.query : query).then((value) {
          setState(() {
            searchedList = value;
            fetched = true;
          });
        });
      }
    }
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: CustomSearchBar(
          controller: _controller,
          haveText: haveText,
          focusNode: _focusNode,
          hintText: "Tìm kiếm",
          onQueryCleared: () async {
            setState(() {
              haveText = false;
              fetched = false;
              query = '';
              _controller.text = '';
              status = false;
              searchedList = [];
            });
          },
          onQueryChanged: (changedQuery) {
            return getSearchSuggestions(changedQuery);
          },
          onSubmitted: (submittedQuery) async {
            setState(() {
              fetched = false;
              haveText = true;
              _focusNode.unfocus();
              query = submittedQuery;
              _controller.text = submittedQuery;
              _controller.selection = TextSelection.fromPosition(
                TextPosition(
                  offset: query.length,
                ),
              );
              status = false;
              searchedList = [];
              searchHistory.value = Hive.box('settings')
                  .get('searchHistory', defaultValue: []).cast<String>();
            });
          },
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 65,
                  left: 20,
                ),
              ),
              Expanded(
                child: (!fetched)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : (query.isEmpty && widget.query.isEmpty)
                        ? SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            physics: const BouncingScrollPhysics(),
                            child: ValueListenableBuilder<List<String>>(
                                valueListenable: searchHistory,
                                builder: (context, searchHistories, widget) {
                                  return Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Wrap(
                                          children: List<Widget>.generate(
                                            searchHistories.length,
                                            (int index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 5.0,
                                                ),
                                                child: GestureDetector(
                                                  child: Chip(
                                                    label: Text(
                                                      searchHistories[index]
                                                          .toString(),
                                                    ),
                                                    labelStyle: TextStyle(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .color,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                    onDeleted: () {
                                                      setState(() {
                                                        searchHistories
                                                            .removeAt(index);
                                                        Hive.box('settings')
                                                            .put(
                                                          'searchHistory',
                                                          searchHistories,
                                                        );
                                                      });
                                                    },
                                                  ),
                                                  onTap: () {
                                                    setState(
                                                      () {
                                                        query = searchHistories[
                                                                index]
                                                            .toString()
                                                            .trim();
                                                        _controller.text =
                                                            query;
                                                        haveText = true;
                                                        _focusNode.unfocus();
                                                        fetched = false;
                                                        status = false;
                                                      },
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          )
                        : searchedList.isEmpty
                            ? emptyScreen(
                                context,
                                0,
                                ':( ',
                                100,
                                "Xin lỗi",
                                60,
                                "Không tìm thấy kết quả nào",
                                20,
                              )
                            : Stack(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4.0, top: 5, bottom: 5),
                                        child: SearchInfoBar(
                                            numberOfResults:
                                                searchedList.length,
                                            onFilterPressed: () {
                                              showFilterDialog(
                                                context,
                                                userDeckFilter,
                                                publicDeckFilter,
                                                cardFilter,
                                                (bool newUserDeckFilter,
                                                    bool newPublicDeckFilter,
                                                    bool newCardFilter) {
                                                  changeFilter.value ^= true;
                                                  userDeckFilter =
                                                      newUserDeckFilter;
                                                  publicDeckFilter =
                                                      newPublicDeckFilter;
                                                  cardFilter = newCardFilter;
                                                  applyFilters(
                                                      userDeckFilter,
                                                      publicDeckFilter,
                                                      cardFilter);
                                                },
                                              );
                                            }),
                                      ),
                                      Divider(
                                        height: 1,
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: ValueListenableBuilder(
                                                valueListenable: changeFilter,
                                                builder: (
                                                  BuildContext context,
                                                  bool hidden,
                                                  Widget? child,
                                                ) {
                                                  return ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        searchedList.length,
                                                    itemBuilder:
                                                        (context, idx) {
                                                      final itemType =
                                                          searchedList[idx]
                                                              .type;
                                                      final APIHanlder
                                                          apiHandler =
                                                          GetIt.I<APIHanlder>();
                                                      if (itemType ==
                                                          ResultType
                                                              .userDeckResult) {
                                                        return !userDeckFilter
                                                            ? const SizedBox()
                                                            : UserDeckTile(
                                                                item:
                                                                    searchedList[
                                                                            idx]
                                                                        .data,
                                                                iconButtonTopRight:
                                                                    const IconButton(
                                                                        icon:
                                                                            Iconify(
                                                                          Mdi.cards_playing_club_multiple,
                                                                          color:
                                                                              Colors.orange,
                                                                        ),
                                                                        tooltip:
                                                                            'Thể loại: Bộ thẻ',
                                                                        onPressed:
                                                                            null),
                                                                iconButtonBottomRight: const IconButton(
                                                                    icon: Iconify(
                                                                        Ic
                                                                            .baseline_lock_person,
                                                                        color: Colors
                                                                            .grey),
                                                                    tooltip:
                                                                        'Không công khai',
                                                                    onPressed:
                                                                        null),
                                                              );
                                                      } else if (itemType ==
                                                          ResultType
                                                              .publicDeckResult) {
                                                        return !publicDeckFilter
                                                            ? const SizedBox()
                                                            : PublicDeckTile(
                                                                item:
                                                                    searchedList[
                                                                            idx]
                                                                        .data,
                                                                iconButtonTopRight: const IconButton(
                                                                    icon: Iconify(
                                                                        Mdi
                                                                            .cards_playing_club_multiple,
                                                                        color: Colors
                                                                            .orange),
                                                                    tooltip:
                                                                        'Thể loại: Bộ thẻ',
                                                                    onPressed:
                                                                        null),
                                                                iconButtonBottomRight: const IconButton(
                                                                    icon: Iconify(
                                                                        Ic
                                                                            .baseline_public,
                                                                        color: Colors
                                                                            .blue),
                                                                    tooltip:
                                                                        'Công khai',
                                                                    onPressed:
                                                                        null),
                                                              );
                                                      } else {
                                                        return !cardFilter
                                                            ? const SizedBox()
                                                            : CardSearchTile(
                                                                itemCard: (searchedList[idx]
                                                                            .data
                                                                        as FlashcardSearch)
                                                                    .card,
                                                                itemDeck: apiHandler
                                                                    .idToDeckWithReviewCards[(searchedList[idx]
                                                                            .data
                                                                        as FlashcardSearch)
                                                                    .card
                                                                    .deckId]!,
                                                                foundTextWidget:
                                                                    (searchedList[idx].data
                                                                            as FlashcardSearch)
                                                                        .searchSentence,
                                                                iconButtonTopRight: const IconButton(
                                                                    icon: Iconify(
                                                                        Mdi
                                                                            .cards_playing_club,
                                                                        color: Colors
                                                                            .red),
                                                                    tooltip:
                                                                        'Thể loại: Thẻ',
                                                                    onPressed:
                                                                        null),
                                                                iconButtonBottomRight: (apiHandler
                                                                        .idToDeckWithReviewCards[(searchedList[idx].data
                                                                                as FlashcardSearch)
                                                                            .card
                                                                            .deckId]!
                                                                        .deck
                                                                        .isPublic
                                                                    ? const IconButton(
                                                                        icon: Iconify(
                                                                            Ic
                                                                                .baseline_public,
                                                                            color: Colors
                                                                                .blue),
                                                                        tooltip:
                                                                            'Công khai',
                                                                        onPressed:
                                                                            null)
                                                                    : const IconButton(
                                                                        icon: Iconify(
                                                                            Ic
                                                                                .baseline_lock_person,
                                                                            color: Colors
                                                                                .grey),
                                                                        tooltip:
                                                                            'Không công khai',
                                                                        onPressed:
                                                                            null)),
                                                              );
                                                      }
                                                    },
                                                  );
                                                }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!done)
                                    Center(
                                      child: SizedBox.square(
                                        dimension: circleProgressSize,
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                                  strokeWidth: 5,
                                                ),
                                                Text(
                                                  "Đang xử lý tìm kiếm",
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
