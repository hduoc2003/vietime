import 'package:flutter/material.dart';

class DeckListInfoBar extends StatelessWidget {
  final int numberOfDecks;
  final VoidCallback onAddPressed;
  final VoidCallback onFilterPressed;
  final VoidCallback onStudyAllPressed;

  DeckListInfoBar({
    required this.numberOfDecks,
    required this.onAddPressed,
    required this.onFilterPressed,
    required this.onStudyAllPressed,
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
                '$numberOfDecks',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 6.0),
              Text(
                'bộ thẻ',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),

          // Right-aligned icons: Filter, Add, Study All
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.book),
                onPressed: onStudyAllPressed,
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: onAddPressed,
              ),
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: onFilterPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Example usage:
void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Deck List'),
        ),
        body: DeckListInfoBar(
          numberOfDecks: 5,
          onAddPressed: () {
            // Add button pressed
          },
          onFilterPressed: () {
            // Filter button pressed
          },
          onStudyAllPressed: () {
            // Study All button pressed
          },
        ),
      ),
    ),
  );
}