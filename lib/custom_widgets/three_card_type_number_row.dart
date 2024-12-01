import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class ThreeCardTypeNumbersRow extends StatelessWidget {
  final int numBlueCards;
  final int numRedCards;
  final int numGreenCards;
  final double fontSize;
  final double boxSize;

  ThreeCardTypeNumbersRow({
    required this.numBlueCards,
    required this.numRedCards,
    required this.numGreenCards,
    this.fontSize = 16.0,
    this.boxSize = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildNumberText(numBlueCards, Colors.blue),
        _buildSizedBox(),
        _buildNumberText(numRedCards, Colors.red),
        _buildSizedBox(),
        _buildNumberText(numGreenCards, Colors.green),
      ],
    );
  }

  Widget _buildNumberText(int number, Color color) {
    return Text(
      number.toStringAsFixed(0),
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildSizedBox() {
    return SizedBox(
      width: boxSize,
    );
  }
}

class ThreeCardTypeNumbersRowWithCards extends StatelessWidget {
  final int numBlueCards;
  final int numRedCards;
  final int numGreenCards;
  final double fontSize;
  final double boxSize;
  final int learnedCards;
  final int totalCards;

  ThreeCardTypeNumbersRowWithCards({
    required this.numBlueCards,
    required this.numRedCards,
    required this.numGreenCards,
    required this.learnedCards,
    required this.totalCards,
    this.fontSize = 16.0,
    this.boxSize = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildNumberText(numBlueCards, Colors.blue),
        _buildSizedBox(),
        _buildNumberText(numRedCards, Colors.red),
        _buildSizedBox(),
        _buildNumberText(numGreenCards, Colors.green),
        Text(
          "  ~  Đã học: ",
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          learnedCards.toString(),
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          "/${totalCards}",
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6.0, bottom: 2),
          child: Iconify(
            Mdi.cards_playing,
            color: Colors.purple,
            size: 20.0,
          ),
        ),
      ],
    );
  }

  Widget _buildNumberText(int number, Color color) {
    return Text(
      number.toStringAsFixed(0),
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildSizedBox() {
    return SizedBox(
      width: boxSize,
    );
  }
}