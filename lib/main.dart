import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:vietime/helpers/api.dart';
import 'package:vietime/helpers/logging.dart';
import 'package:vietime/screens/game_screen.dart';
import 'package:vietime/screens/home/home_screen.dart';
import 'package:vietime/screens/login_screen.dart';
import 'package:vietime/screens/profile_screen.dart';
import 'package:vietime/screens/search_screen.dart';
import 'package:vietime/services/api_handler.dart';
import 'package:vietime/services/theme_manager.dart';

import 'custom_widgets/custom_physics.dart';
import 'custom_widgets/snackbar.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await Hive.initFlutter('Vietime');
  } else {
    await Hive.initFlutter();
  }
  await openHiveBox('settings');
  await openHiveBox('publicDeckViews');
  await openHiveBox('cache', limit: true);
  await dotenv.load();
  await initAPIHandler();
  await initLogging();
  runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => new ThemeNotifier(),
    child: MyApp(),
  ));
  await Future.delayed(const Duration(milliseconds: 1));
  FlutterNativeSplash.remove();
}

Future<void> initAPIHandler() async {
  final APIHanlder apiHanlder = APIHanlder();
  GetIt.I.registerSingleton<APIHanlder>(apiHanlder);
  await apiHanlder.initData();
  apiHanlder.initNecessaryData();
}

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
    Logger.root.severe('Failed to open $boxName Box', error, stackTrace);
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = dir.path;
    File dbFile = File('$dirPath/$boxName.hive');
    File lockFile = File('$dirPath/$boxName.lock');
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      dbFile = File('$dirPath/Vietime/$boxName.hive');
      lockFile = File('$dirPath/Vietime/$boxName.lock');
    }
    await dbFile.delete();
    await lockFile.delete();
    await Hive.openBox(boxName);
    throw 'Failed to open $boxName Box\nError: $error';
  });
  // clear box if it grows large
  if (limit && box.length > 500) {
    box.clear();
  }
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

  void _onRebuildMainPage() {
    setState(() {});
  }

  void _onResetHomePage() {
    _selectedIndex.value = 0;
  }

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
    _pageController.jumpToPage(
      index,
    );
  }

  Future<void> handleWillPop(BuildContext context) async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            now.difference(backButtonPressTime!) >
                const Duration(milliseconds: 2700);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = now;
      ShowSnackBar().showSnackBar(
        context,
        "Nhấn trở về thêm một lần nữa để thoát",
        duration: const Duration(milliseconds: 2500),
        noAction: true,
      );

      return;
    }
    SystemNavigator.pop();
    return;
  }

  @override
  void initState() {
    super.initState();
    GetIt.I<APIHanlder>().setOnRebuildMainPage(_onRebuildMainPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              title: MyApp.title,
              theme: theme.getTheme(),
              home: ValueListenableBuilder<bool>(
                  valueListenable: GetIt.I<APIHanlder>().isLoggedIn,
                  builder: (context, value, child) {
                    return value
                        ? Scaffold(
                            resizeToAvoidBottomInset: false,
                            body: PopScope(
                              canPop: false,
                              onPopInvoked: (bool didPop) {
                                if (didPop) {
                                  return;
                                }
                                handleWillPop(context);
                              },
                              child: SafeArea(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: PageView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              onPageChanged: (index) {
                                                _selectedIndex.value = index;
                                              },
                                              controller: _pageController,
                                              children: [
                                                HomePage(),
                                                SearchPage(
                                                  query: "",
                                                ),
                                                // GamePage(),
                                                ProfilePage(
                                                  setDarkMode: () {
                                                    theme.setDarkMode();
                                                  },
                                                  setLightMode: () {
                                                    theme.setLightMode();
                                                  },
                                                ),
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
                                  builder: (BuildContext context,
                                      int indexValue, Widget? child) {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      height: 60,
                                      child: SalomonBottomBar(
                                        currentIndex: indexValue,
                                        onTap: (i) => _onItemTapped(i),
                                        items: [
                                          /// Home
                                          SalomonBottomBarItem(
                                            // icon: Icon(Iconsax.home_1),
                                            icon: const Iconify(
                                                Ri.home_smile_2_fill,
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
                                          // SalomonBottomBarItem(
                                          //   icon: Iconify(Ri.game_fill, color: Colors.green),
                                          //   title: Text("Game"),
                                          //   selectedColor: Colors.green,
                                          // ),

                                          /// Profile
                                          SalomonBottomBarItem(
                                            icon: Iconify(Ri.user_5_fill,
                                                color: Colors.blue),
                                            title: Text("Profile"),
                                            selectedColor: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          )
                        : LoginPage(onResetHomePage: _onResetHomePage);
                  }),
            ));
  }

  void changeTheme(bool isDarkMode) {
    setState(() {
      isDarkMode = isDarkMode;
    });
  }
}
