import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/ion.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:vietime/screens/deck_list_screen.dart';
import 'package:vietime/screens/home/widgets/deck_horizontal_list.dart';
import 'package:iconify_flutter/icons/carbon.dart';

import '../../helpers/loader_dialog.dart';
import '../../services/api_handler.dart';
import '../../services/mock_data.dart';
import '../../services/theme_manager.dart';
import 'notification_screen.dart';

class HomePage extends StatefulWidget {
  static const title = 'Home';

  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isHeartIconClicked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            getAppBarHome(context),
            getUserDeckWidget(),
            SizedBox(
              height: 15,
            ),
            getPublicDeckWidget()
          ],
        ),
      ),
    );
  }

  Widget getAppBarHome(BuildContext context) {
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    return Row(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 15),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: Colors.white, width: 3)),
            width: 60,
            height: 60,
            child: Image.asset('assets/user_avatar.png'),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Chào mừng,",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 21,
                  color: myColors.homeWelcomeColor,
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: GetIt.I<APIHanlder>().userChanged,
                  builder: (
                    BuildContext context,
                    bool hidden,
                    Widget? child,
                  ) {
                    return Text(
                      GetIt.I<APIHanlder>().user.name.split(' ').last,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                        color: myColors.homeNameColor,
                      ),
                    );
                  })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: GestureDetector(
            onTap: () {
              showLoaderDialog(context);
              GetIt.I<APIHanlder>().initData().then((_) {
                Navigator.pop(context);
              });
              setState(() {
                isHeartIconClicked ^= true;
              });
            },
            child: Iconify(
              Mdi.reload,
              color: Colors.pink,
              size: 32,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: NotificationIconRedDot(),
        ),
      ],
    );
  }

  Widget getUserDeckWidget() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, right: 5),
            child: Row(
              children: <Widget>[
                Text(
                  'Bộ thẻ của bạn',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 23,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Iconify(
                  Mdi.cards_playing_club_multiple,
                  color: Colors.orange,
                  size: 20,
                ),
                const Expanded(child: SizedBox()),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeckListScreen(
                                decksList: GetIt.I<APIHanlder>().userDecks,
                                isPublic: false,
                              )),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'XEM TẤT CẢ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          height: 1.5,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          letterSpacing: 0.3,
                          color: Colors.orange,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3.0),
                        child: Iconify(
                          Ic.outline_chevron_right,
                          color: Colors.orange,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<bool>(
              valueListenable: GetIt.I<APIHanlder>().userDecksChanged,
              builder: (context, value, _) {
                return DeckHorizontalList(
                  itemCountPerGroup: 3,
                  deckType: 0,
                  decksList: GetIt.I<APIHanlder>().userDecks,
                );
              })
        ]);
  }

  Widget getPublicDeckWidget() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, right: 5),
            child: Row(
              children: <Widget>[
                Text(
                  'Bộ thẻ công khai',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 23,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Iconify(
                  Ri.global_fill,
                  color: Colors.orange,
                  size: 20,
                ),
                const Expanded(child: SizedBox()),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeckListScreen(
                                decksList: GetIt.I<APIHanlder>().publicDecks,
                                isPublic: true,
                              )),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'XEM TẤT CẢ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          height: 1.5,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          letterSpacing: 0.3,
                          color: Colors.orange,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3.0),
                        child: Iconify(
                          Ic.outline_chevron_right,
                          color: Colors.orange,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DeckHorizontalList(
            itemCountPerGroup: 2,
            deckType: 1,
            decksList: GetIt.I<APIHanlder>().publicDecks,
          )
        ]);
  }
}
