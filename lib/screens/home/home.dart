import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:vietime/screens/home/widgets/deck_horizontal_list.dart';
class HomePage extends StatefulWidget {
  static const title = 'Home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //White
      color: Color(0xFFFFFFFF),
      child: Scaffold(
        //Transparent
        backgroundColor: Color(0x00000000),
        body: Column(
          children: <Widget> [
            getAppBarHome(),
            getUserDeckWidget(),
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
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: 60,
              height: 60,
              child: Image.asset('assets/user_placeholder.png'),
            ),
          ),
          const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Chào mừng,",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: Color(0xFF3A5160), //grey
                    ),
                  ),
                  Text(
                    "HynDuf",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: Color(0xFF17262A), //darker
                    ),
                  ),
                ],
              ),
          )
        ],
      );
  }

  Widget getUserDeckWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 5),
          child: Row(
            children: <Widget>[
              Text(
                  'Bộ thẻ của bạn',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 25,
                    letterSpacing: 0.4,
                  ),
                ),
              SizedBox(width: 10,),
              Iconify(Mdi.cards_playing_club_multiple, color: Colors.cyan, size: 20,),
              Expanded(
                child: Text(
                    'XEM TẤT CẢ',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        height: 1.5,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        letterSpacing: 0.3,
                        color: Colors.cyan,
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(bottom: 3.0),
                child: Iconify(
                  Ic.outline_chevron_right,
                  color: Colors.cyan,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
        DeckHorizontalList(itemCountPerGroup: 3,)
      ]
    );
  }

  Widget getPublicDeckWidget() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 5),
            child: Row(
              children: <Widget>[
                Text(
                  'Bộ thẻ công khai',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 25,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(width: 10,),
                Iconify(Ri.global_fill, color: Colors.cyan, size: 20,),
                Expanded(
                  child: Text(
                    'XEM TẤT CẢ',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      letterSpacing: 0.3,
                      color: Colors.cyan,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 3.0),
                  child: Iconify(
                    Ic.outline_chevron_right,
                    color: Colors.cyan,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
          DeckHorizontalList(itemCountPerGroup: 2,)
        ]
    );
  }
}