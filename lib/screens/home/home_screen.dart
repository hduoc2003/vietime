import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:vietime/screens/deck_list_screen.dart';
import 'package:vietime/screens/home/widgets/deck_horizontal_list.dart';
import 'package:iconify_flutter/icons/carbon.dart';

import '../../services/mock_data.dart';
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
      //White
      color: Color(0xFFFFFFFF),
      child: Scaffold(
        //Transparent
        backgroundColor: Color(0x00000000),
        body: Column(
          children: <Widget>[
            getAppBarHome(),
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

  Widget getAppBarHome() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 15),
          child: Container(
            width: 60,
            height: 60,
            child: Image.asset('assets/user_placeholder.png'),
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
                  color: Color(0xFF3A5160), //grey
                ),
              ),
              Text(
                "HynDuf",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                  color: Color(0xFF17262A), //darker
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                isHeartIconClicked ^= true;
              });
            },
            child: Iconify(
              isHeartIconClicked ? Ri.heart_2_fill : Ri.heart_2_line,
              color: Color(0xffe30e51), // Change color as needed
              size: 30,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Iconify(
              Carbon.notification_filled,
              color: Color(0xffe8e01a), // Change color as needed
              size: 30,
            ),
          ),
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
                      MaterialPageRoute(builder: (context) => DeckListScreen(decksList: mockDecksList,)),
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
            itemCountPerGroup: 3,
            deckType: 0,
            decksList: mockDecksList,
          )
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
                      MaterialPageRoute(builder: (context) => DeckListScreen(decksList: mockDecksList,)),
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
            decksList: mockDecksList,
          )
        ]);
  }
}