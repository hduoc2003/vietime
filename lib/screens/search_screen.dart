import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:logging/logging.dart';
import 'package:vietime/custom_widgets/card_search_tile.dart';
import 'package:vietime/custom_widgets/deck_list_tile.dart';
import 'package:vietime/entity/search.dart';

import '../custom_widgets/empty_screen.dart';
import '../custom_widgets/search_bar.dart';
import '../entity/card.dart';

class SearchPage extends StatefulWidget {
  final String query;
  final bool autofocus;
  final List<Flashcard> allCards;
  const SearchPage({
    super.key,
    required this.query,
    required this.allCards,
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

  List searchHistory =
  Hive.box('settings').get('searchHistory', defaultValue: []) as List;

  final TextEditingController _controller = TextEditingController();

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
    final List<SearchResult> results = [];
    return results;
  }

  Future<List<String>> getSearchSuggestions(String query) async {
    final List<String> results = [];
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
        child: Column(
        children: [
        Expanded(
        child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: CustomSearchBar(
        controller: _controller,
        autofocus: widget.autofocus,
        hintText: "Tìm kiếm",
        onQueryChanged: (changedQuery) {
      return getSearchSuggestions(changedQuery);
    },
    onSubmitted: (submittedQuery) async {
    setState(() {
    fetched = false;
    query = submittedQuery;
    _controller.text = submittedQuery;
    _controller.selection = TextSelection.fromPosition(
    TextPosition(
    offset: query.length,
                      ),
                      );
                      status = false;
                      searchedList = [];
    });
    },
    body: Column(
    children: [
    const Padding(
    padding: EdgeInsets.only(
    top: 70,
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
    horizontal: 15,
    ),
    physics: const BouncingScrollPhysics(),
    child: Column(
    children: [
    Align(
    alignment: Alignment.topLeft,
    child: Wrap(
    children: List<Widget>.generate(
    searchHistory.length,
    (int index) {
    return Padding(
    padding:
    const EdgeInsets.symmetric(
    horizontal: 5.0,
    ),
    child: GestureDetector(
    child: Chip(
    label: Text(
    searchHistory[index]
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
    searchHistory
        .removeAt(index);
    Hive.box('settings')
        .put(
    'searchHistory',
    searchHistory,
    );
    });
    },
    ),
    onTap: () {
    setState(
    () {
    fetched = false;
    query =
    searchHistory[index]
        .toString()
        .trim();
    _controller.text =
    query;
    status = false;
    fetched = false;
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
                                  ),
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
    SingleChildScrollView(
    padding: const EdgeInsets.only(
    left: 10,
    right: 10,
                                          ),
    physics:
    const BouncingScrollPhysics(),
    child: ListView.builder(
    physics:
    const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
      itemCount: searchedList.length,
    itemBuilder: (context, idx) {
    final itemType =
    searchedList[idx].type;
    if (itemType ==
        ResultType.userDeckResult) {
      return UserDeckTile(
        item: searchedList[idx].data,
        iconButtonTopRight:
        const IconButton(
            icon: Iconify(Mdi
                .cards_playing_club_multiple),
            tooltip:
            'Thể loại: Bộ thẻ',
            onPressed: null),
        iconButtonBottomRight:
        const IconButton(
            icon: Iconify(Ic
                .baseline_lock_person),
            tooltip:
            'Không công khai',
            onPressed: null),
      );
    } else if (itemType ==
        ResultType.publicDeckResult) {
      return PublicDeckTile(
        item: searchedList[idx].data,
        iconButtonTopRight:
        const IconButton(
            icon: Iconify(Mdi
                .cards_playing_club_multiple),
            tooltip:
            'Thể loại: Bộ thẻ',
            onPressed: null),
        iconButtonBottomRight:
        const IconButton(
            icon: Iconify(Ic
                .baseline_public),
            tooltip: 'Công khai',
            onPressed: null),
      );
    } else {
      return CardSearchTile(
        itemCard: searchedList[idx].data,
        itemDeck: searchedList[idx].data,
        iconButtonTopRight:
        const IconButton(
            icon: Iconify(Mdi
                .cards_playing_club),
            tooltip:
            'Thể loại: Thẻ',
            onPressed: null),
        iconButtonBottomRight:
        const IconButton(
            icon: Iconify(Ic
                .baseline_lock_person),
            tooltip:
            'Không công khai',
            onPressed: null),
      );
    }
    },
                                          ),
                                        ),
            if (!done)
      Center(
    child: SizedBox.square(
    dimension: circleProgressSize,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    15,
                                                  ),
                                                ),
        clipBehavior: Clip.antiAlias,
        child: Center(
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceEvenly,
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
    ),
        ],
      ),
    );
  }
}