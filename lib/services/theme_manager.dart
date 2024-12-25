import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@immutable
class MyColors extends ThemeExtension<MyColors> {
  MyColors({
    required this.homeWelcomeColor,
    required this.homeNameColor,
    required this.deckTileBackground,
    required this.progressBarBackground,
    required this.cardBackground,
    required this.backgroundColor2,
    required this.grey300,
    required this.grey200,
    required this.grey100,
    required this.textFieldReadOnlyColor,
    required this.textFieldColor,
    required this.selectedAnswer,
    required this.buttonIdleColor,
    required this.buttonTextColor,
    required this.greenBackground,
    required this.redBackground,
    required this.panelColor,
  });

  final Color? homeWelcomeColor;
  final Color? homeNameColor;
  final Color? deckTileBackground;
  final Color? progressBarBackground;
  final Color? cardBackground;
  final Color? backgroundColor2;
  final Color? grey300;
  final Color? grey200;
  final Color? grey100;
  final Color? textFieldReadOnlyColor;
  final Color? textFieldColor;
  final Color? selectedAnswer;
  final Color? buttonIdleColor;
  final Color? buttonTextColor;
  final Color? greenBackground;
  final Color? redBackground;
  final Color? panelColor;

  @override
  MyColors copyWith(
      {Color? homeWelcomeColor,
      Color? homeNameColor,
      Color? deckTileBackground,
      Color? progressBarBackground,
      Color? backgroundColor2,
      Color? grey300,
      Color? grey200,
      Color? grey100,
      Color? textFieldReadOnlyColor,
      Color? textFieldColor,
      Color? selectedAnswer,
      Color? buttonIdleColor,
      Color? buttonTextColor,
      Color? greenBackground,
      Color? redBackground,
      Color? panelColor,
      Color? cardBackground}) {
    return MyColors(
      homeWelcomeColor: homeWelcomeColor ?? this.homeWelcomeColor,
      homeNameColor: homeNameColor ?? this.homeNameColor,
      deckTileBackground: deckTileBackground ?? this.deckTileBackground,
      progressBarBackground:
          progressBarBackground ?? this.progressBarBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      backgroundColor2: backgroundColor2 ?? this.backgroundColor2,
      grey300: grey300 ?? this.grey300,
      grey200: grey200 ?? this.grey200,
      grey100: grey200 ?? this.grey100,
      textFieldReadOnlyColor:
          textFieldReadOnlyColor ?? this.textFieldReadOnlyColor,
      textFieldColor: textFieldColor ?? this.textFieldColor,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      buttonIdleColor: buttonIdleColor ?? this.buttonIdleColor,
      buttonTextColor: buttonTextColor ?? this.buttonTextColor,
      greenBackground: greenBackground ?? this.greenBackground,
      redBackground: redBackground ?? this.redBackground,
      panelColor: panelColor ?? this.panelColor,
    );
  }

  @override
  MyColors lerp(MyColors? other, double t) {
    if (other is! MyColors) {
      return this;
    }
    return MyColors(
      homeWelcomeColor: Color.lerp(homeWelcomeColor, other.homeWelcomeColor, t),
      homeNameColor: Color.lerp(homeNameColor, other.homeNameColor, t),
      deckTileBackground:
          Color.lerp(deckTileBackground, other.deckTileBackground, t),
      progressBarBackground:
          Color.lerp(progressBarBackground, other.progressBarBackground, t),
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t),
      backgroundColor2: Color.lerp(backgroundColor2, other.backgroundColor2, t),
      grey300: Color.lerp(grey300, other.grey300, t),
      grey200: Color.lerp(grey200, other.grey200, t),
      grey100: Color.lerp(grey100, other.grey100, t),
      textFieldReadOnlyColor:
          Color.lerp(textFieldReadOnlyColor, other.textFieldReadOnlyColor, t),
      textFieldColor: Color.lerp(textFieldColor, other.textFieldColor, t),
      selectedAnswer: Color.lerp(selectedAnswer, other.selectedAnswer, t),
      buttonIdleColor: Color.lerp(buttonIdleColor, other.buttonIdleColor, t),
      buttonTextColor: Color.lerp(buttonTextColor, other.buttonTextColor, t),
      redBackground: Color.lerp(redBackground, other.redBackground, t),
      greenBackground: Color.lerp(greenBackground, other.greenBackground, t),
      panelColor: Color.lerp(panelColor, other.panelColor, t),
    );
  }
}

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData.dark().copyWith(
    dividerColor: Colors.grey[300],
    appBarTheme: AppBarTheme(
      color: Color(0xff141F25),
      foregroundColor: Colors.white,
    ),
    dialogBackgroundColor: Color(0xff19262e),
    scaffoldBackgroundColor: Color(0xff141F25),
    extensions: <ThemeExtension<dynamic>>[
      MyColors(
          homeWelcomeColor: Colors.white60,
          homeNameColor: Colors.white,
          deckTileBackground: Color(0xff1e2f38),
          progressBarBackground: Color(0xff3d5f73),
          backgroundColor2: Color(0xffd5e2eb),
          cardBackground: Color(0xff1e2f38),
          grey200: Colors.grey[700],
          grey300: Colors.grey[600],
          grey100: Color(0xff3d5f73),
          textFieldReadOnlyColor: Color(0xff1e2f38),
          selectedAnswer: Color(0xff2a3e47),
          textFieldColor: Color(0xff2f4957),
          buttonIdleColor: Color(0xff38464F),
          buttonTextColor: Color(0xff52636B),
          greenBackground: Color(0xff2a3e47),
          panelColor: Color(0xff1a2930),
          redBackground: Color(0xff2a3e47)),
    ],
  );

  final lightTheme = ThemeData.light().copyWith(
    extensions: <ThemeExtension<dynamic>>[
      MyColors(
          homeWelcomeColor: Color(0xFF3A5160),
          homeNameColor: Color(0xFF17262A),
          deckTileBackground: Colors.grey[200],
          progressBarBackground: Color(0xffD9D9D9),
          cardBackground: Colors.grey[100],
          backgroundColor2: Color(0xffd5e2eb),
          grey200: Colors.grey[200],
          grey300: Colors.grey[300],
          textFieldReadOnlyColor: Colors.grey[200],
          grey100: Colors.grey[100],
          selectedAnswer: Colors.grey[100],
          buttonIdleColor: Color(0xfff0f2f0),
          buttonTextColor: Color(0xffC7C6C6),
          textFieldColor: Colors.grey[200],
          greenBackground: Color(0xffd6fcb8),
          panelColor: Colors.white,
          redBackground: Color(0xfffcb8b8)),
    ],
  );

  late ThemeData _themeData;
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    bool isDarkMode =
        Hive.box('settings').get('darkMode', defaultValue: false) as bool;
    if (!isDarkMode) {
      _themeData = lightTheme;
    } else {
      _themeData = darkTheme;
    }
    notifyListeners();
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    Hive.box('settings').put('darkMode', true);
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    Hive.box('settings').put('darkMode', false);
    notifyListeners();
  }
}
