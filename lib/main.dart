import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final title = 'Vietime';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyApp.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            /// Home
            SalomonBottomBarItem(
              // icon: Icon(Iconsax.home_1),
              icon: const Iconify(Ri.home_smile_2_fill, color: Colors.purple),
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
      ),
    );
  }
}
