import 'package:flutter/material.dart';

class SearchInfoBar extends StatelessWidget {
  final int numberOfResults;
  final VoidCallback onFilterPressed;

  SearchInfoBar({
    required this.numberOfResults,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left-aligned element: Number of Decks
          Row(
            children: [
              Text(
                '$numberOfResults',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 6.0),
              Text(
                'kết quả',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),

          TextButton(
            onPressed: onFilterPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lọc',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 8,),
                Icon(Icons.filter_list, color: Colors.black),
              ],
            ),
          )
        ],
      ),
    );
  }
}