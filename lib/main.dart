import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:vietime/helpers/logging.dart';
import 'package:vietime/screens/game.dart';
import 'package:vietime/screens/home.dart';
import 'package:vietime/screens/profile.dart';
import 'package:vietime/screens/search.dart';

import 'custom_widgets/snackbar.dart';

void main() {
  initLogging();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final title = 'Vietime';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  final PageController _pageController = PageController();
  DateTime? backButtonPressTime;

  void _onItemTapped(int index) {
    Logger.root.info("TEST INFO");
    _selectedIndex.value = index;
    _pageController.jumpToPage(
      index,
    );
  }

  Future<bool> handleWillPop(BuildContext context) async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            now.difference(backButtonPressTime!) > const Duration(milliseconds: 2700);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = now;
      ShowSnackBar().showSnackBar(
        context,
        "Nhấn trở về thêm một lần nữa để thoát",
        duration: const Duration(milliseconds: 2500),
        noAction: true,
      );
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyApp.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Builder(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: WillPopScope(
              onWillPop: () => handleWillPop(context),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: PageView(
                              // physics: const CustomPhysics(),
                              onPageChanged: (index) {
                                _selectedIndex.value = index;
                              },
                              controller: _pageController,
                              children: [
                                HomePage(),
                                SearchPage(),
                                GamePage(),
                                ProfilePage(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: ValueListenableBuilder(
                  valueListenable: _selectedIndex,
                  builder: (BuildContext context, int indexValue, Widget? child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: 60,
                      child: SalomonBottomBar(
                        currentIndex: indexValue,
                        onTap: (i) => _onItemTapped(i),
                        items: [
                          /// Home
                          SalomonBottomBarItem(
                            // icon: Icon(Iconsax.home_1),
                            icon: const Iconify(Ri.home_smile_2_fill,
                                color: Colors.purple),
                            title: Text("Home"),
                            selectedColor: Colors.purple,
                          ),

                          /// Search
                          SalomonBottomBarItem(
                            icon: const Iconify(
                              Ri.search_eye_fill,
                              color: Colors.orange,
                            ),
                            title: Text("Search"),
                            selectedColor: Colors.orange,
                          ),

                          /// Profile
                          SalomonBottomBarItem(
                            icon: Iconify(Ri.game_fill, color: Colors.green),
                            title: Text("Game"),
                            selectedColor: Colors.green,
                          ),

                          /// Profile
                          SalomonBottomBarItem(
                            icon: Iconify(Ri.user_5_fill, color: Colors.blue),
                            title: Text("Profile"),
                            selectedColor: Colors.blue,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          );
        }
      ),
    );
  }
}
