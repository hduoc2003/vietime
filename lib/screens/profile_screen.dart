import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:vietime/custom_widgets/animated_progress_bar.dart';
import 'package:colorful_iconify_flutter/icons/fxemoji.dart';
import 'package:vietime/screens/settings/settings_screen.dart';

import '../services/api_handler.dart';
import '../services/theme_manager.dart';

final List<String> rankLabels = [
  "Bronze",
  "Silver",
  "Gold",
  "Sapphire",
  "Ruby",
  "Emerald",
];

final List<String> romanNumImage = [
  "I.png",
  "II.png",
  "III.png",
  "IV.png",
  "V.png",
  "VI.png",
];

final List<String> rankImage = [
  "bronze.png",
  "silver.png",
  "gold.png",
  "sapphire.png",
  "ruby.png",
  "emerald.png"
];
final List<Color> rankColor = [
  Color(0xffc29876),
  Color(0xffc3d1dd),
  Color(0xfffac432),
  Color(0xff2ca6e2),
  Color(0xffee5251),
  Color(0xff7abd18),
];

final List<Color> rankInnerColor = [
  Color(0xffE8BB91),
  Color(0xffE0EAF2),
  Color(0xffFDEA65),
  Color(0xff5CCAFF),
  Color(0xffFE8787),
  Color(0xff97E322),
];

class ProfilePage extends StatefulWidget {
  final Function setDarkMode;
  final Function setLightMode;
  ProfilePage({required this.setLightMode, required this.setDarkMode});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final MyColors myColors = Theme.of(context).extension<MyColors>()!;
    double progressBarWidth = MediaQuery.of(context).size.width * 0.7;
    double wallpaperHeight = MediaQuery.of(context).size.height / 3.5 - 20;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: ValueListenableBuilder(
                  valueListenable: GetIt.I<APIHanlder>().userChanged,
                  builder: (
                    BuildContext context,
                    bool hidden,
                    Widget? child,
                  ) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: wallpaperHeight,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/wallpaper.jpg'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16, top: wallpaperHeight / 1.8),
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 4.0,
                                    color: myColors.homeNameColor!
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: myColors.backgroundColor2,
                                  radius: 48,
                                  backgroundImage:
                                      AssetImage('assets/user_avatar.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              GetIt.I<APIHanlder>().user.name,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Tham gia vào Tháng ${GetIt.I<APIHanlder>().user.createdAt.month}, '
                              '${GetIt.I<APIHanlder>().user.createdAt.year}',
                              style: TextStyle(
                                  wordSpacing: 1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[500]!),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Add your logic for 'X followers' button
                                },
                                child: Text(
                                  '2 followers',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                              Text(
                                '|',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w900),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Add your logic for 'Y following' button
                                },
                                child: Text(
                                  '1 following',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  'assets/${rankImage[min(6, GetIt.I<APIHanlder>().user.level) - 1]}', // Replace with your ranking icon asset
                                  height: 58,
                                  width: 58,
                                ),
                                SizedBox(height: 8),
                                Image.asset(
                                  'assets/${romanNumImage[min(6, GetIt.I<APIHanlder>().user.level) - 1]}', // Replace with your ranking icon asset
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                            SizedBox(width: 16),
                            Column(
                              children: [
                                AnimatedProgressBar(
                                    width: progressBarWidth,
                                    height: 23,
                                    progress: GetIt.I<APIHanlder>().user.xp /
                                        GetIt.I<APIHanlder>().user.xpToLevelUp,
                                    progressColor: rankColor[min(6,
                                            GetIt.I<APIHanlder>().user.level) -
                                        1],
                                    innerProgressColor: rankInnerColor[min(6,
                                            GetIt.I<APIHanlder>().user.level) -
                                        1]),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Iconify(Ph.lightning_fill,
                                        color: Colors.yellow),
                                    SizedBox(width: 4),
                                    Text(
                                      '${GetIt.I<APIHanlder>().user.xp} / ${GetIt.I<APIHanlder>().user.xpToLevelUp}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Heading
                              Text(
                                'Thông số',
                                style: TextStyle(
                                  fontSize:
                                      24.0, // Adjust the font size as needed
                                  fontWeight: FontWeight.w900,
                                ),
                              ),

                              SizedBox(
                                  height:
                                      12.0), // Add some space between heading and grid

                              // Grid
                              GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.0,
                                mainAxisSpacing: 12.0,
                                childAspectRatio: (350 / 141),
                                shrinkWrap: true,
                                children: [
                                  // Streak cell
                                  GridCell(
                                    icon: Iconify(
                                      Fxemoji.fire,
                                      size: 30,
                                    ),
                                    title: GetIt.I<APIHanlder>()
                                        .user
                                        .streak
                                        .toString(),
                                    subtitle: 'Streak',
                                  ),
                                  GridCell(
                                    icon: Image.asset(
                                      'assets/bolt.png',
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                    title: (GetIt.I<APIHanlder>().user.level *
                                                (GetIt.I<APIHanlder>()
                                                        .user
                                                        .level -
                                                    1) *
                                                50 +
                                            GetIt.I<APIHanlder>().user.xp)
                                        .toString(),
                                    subtitle: 'Kinh nghiệm',
                                  ),
                                  GridCell(
                                    icon: Image.asset(
                                      'assets/${rankImage[min(6, GetIt.I<APIHanlder>().user.level) - 1]}',
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                    title: rankLabels[min(6,
                                            GetIt.I<APIHanlder>().user.level) -
                                        1],
                                    subtitle: 'Xếp hạng',
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: GetIt.I<APIHanlder>()
                                          .userDecksChanged,
                                      builder: (
                                        BuildContext context,
                                        bool hidden,
                                        Widget? child,
                                      ) {
                                        return GridCell(
                                          icon: Iconify(
                                            Mdi.cards_playing_club_multiple,
                                            color: Colors.purple,
                                            size: 30,
                                          ),
                                          title: GetIt.I<APIHanlder>()
                                              .userDecks
                                              .length
                                              .toString(),
                                          subtitle: 'Số bộ thẻ',
                                        );
                                      })
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }),
            ),
          ),
          Positioned(
            top: 25.0,
            right: 25.0,
            child: Container(
              height: 55.0,
              width: 55.0,
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: myColors.backgroundColor2,
                  elevation: 5,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(
                          setDarkMode: widget.setDarkMode,
                          setLightMode: widget.setLightMode,
                        ),
                      ),
                    );
                  },
                  tooltip: 'Settings',
                  child: Icon(
                    Icons.settings,
                    color: Colors.grey[700]!,
                    size: 32,
                  ),
                  shape: CircleBorder(
                    side: BorderSide(
                      color: Colors.grey[200]!, //
                      width: 2.0, // Set border width
                    ),
                  ),
                  heroTag: null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridCell extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;

  const GridCell({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.grey[300]!,
            width: 2), // Grey border with increased weight
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Row(
        children: [
          // Icon on the left
          icon,
          SizedBox(width: 15.0),

          // Main text and subtitle in a column
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
