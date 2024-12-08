import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CustomSearchBar extends StatefulWidget {
  final Widget body;
  final bool autofocus;
  final Widget? leading;
  final String? hintText;
  final TextEditingController controller;
  final Function(String)? onQueryChanged;
  final Function()? onQueryCleared;
  final Function(String) onSubmitted;
  const CustomSearchBar({
    super.key,
    this.leading,
    this.hintText,
    this.autofocus = false,
    this.onQueryChanged,
    this.onQueryCleared,
    required this.body,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  String tempQuery = '';
  String query = '';
  final ValueNotifier<bool> hide = ValueNotifier<bool>(true);
  final ValueNotifier<List> suggestionsList = ValueNotifier<List>([]);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.body,
        ValueListenableBuilder(
          valueListenable: hide,
          builder: (
              BuildContext context,
              bool hidden,
              Widget? child,
              ) {
            return Visibility(
              visible: !hidden,
              child: GestureDetector(
                onTap: () {
                  hide.value = true;
                },
              ),
            );
          },
        ),
        Column(
          children: [
            Card(
              margin: const EdgeInsets.fromLTRB(
                18.0,
                10.0,
                18.0,
                15.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              elevation: 8.0,
              child: ColoredBox(
                color: Colors.grey[900]!,
                child: SizedBox(
                  height: 52.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Center(
                      child: TextField(
                        controller: widget.controller,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.transparent,
                            ),
                          ),
                          fillColor: Theme.of(context).colorScheme.secondary,
                          prefixIcon: widget.leading,
                          suffixIcon: ValueListenableBuilder(
                            valueListenable: hide,
                            builder: (
                                BuildContext context,
                                bool hidden,
                                Widget? child,
                                ) {
                              return Visibility(
                                visible: !hidden,
                                child: IconButton(
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () {
                                    widget.controller.text = '';
                                    suggestionsList.value = [];
                                    if (widget.onQueryCleared != null) {
                                      widget.onQueryCleared!.call();
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                          border: InputBorder.none,
                          hintText: widget.hintText,
                        ),
                        autofocus: widget.autofocus,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onChanged: (val) {
                          tempQuery = val;
                          hide.value = false;
                          Future.delayed(
                            const Duration(
                              milliseconds: 600,
                            ),
                                () async {
                              if (tempQuery == val &&
                                  tempQuery.trim() != '' &&
                                  tempQuery != query) {
                                query = tempQuery;
                                suggestionsList.value =
                                await widget.onQueryChanged!(tempQuery)
                                as List;
                              }
                            },
                          );
                        },
                        onSubmitted: (submittedQuery) {
                          if (submittedQuery.trim() != '') {
                            query = submittedQuery;
                            widget.onSubmitted(submittedQuery);
                            if (!hide.value) hide.value = true;
                            List searchQueries = Hive.box('settings')
                                .get('searchHistory', defaultValue: []) as List;
                            if (searchQueries.contains(query)) {
                              searchQueries.remove(query);
                            }
                            searchQueries.insert(0, query);
                            if (searchQueries.length > 10) {
                              searchQueries = searchQueries.sublist(0, 10);
                            }
                            Hive.box('settings').put('searchHistory', searchQueries);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: hide,
              builder: (
                  BuildContext context,
                  bool hidden,
                  Widget? child,
                  ) {
                return Visibility(
                  visible: !hidden,
                  child: ValueListenableBuilder(
                    valueListenable: suggestionsList,
                    builder: (
                        BuildContext context,
                        List suggestedList,
                        Widget? child,
                        ) {
                      return suggestedList.isEmpty
                          ? const SizedBox()
                          : Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 18.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        elevation: 8.0,
                        child: SizedBox(
                          height: min(
                            MediaQuery.of(context).size.height / 1.75,
                            70.0 * suggestedList.length,
                          ),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            shrinkWrap: true,
                            itemExtent: 70.0,
                            itemCount: suggestedList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading:
                                const Icon(CupertinoIcons.search),
                                title: Text(
                                  suggestedList[index].toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  widget.onSubmitted(
                                    suggestedList[index].toString(),
                                  );
                                  hide.value = true;
                                  List searchQueries =
                                  Hive.box('settings').get(
                                    'searchHistory',
                                    defaultValue: [],
                                  ) as List;
                                  if (searchQueries.contains(
                                    suggestedList[index].toString(),
                                  )) {
                                    searchQueries.remove(
                                      suggestedList[index].toString(),
                                    );
                                  }
                                  searchQueries.insert(
                                    0,
                                    suggestedList[index].toString(),
                                  );
                                  if (searchQueries.length > 10) {
                                    searchQueries =
                                        searchQueries.sublist(0, 10);
                                  }
                                  Hive.box('settings')
                                      .put('searchHistory', searchQueries);
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}