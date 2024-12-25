import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';

import '../entity/card.dart';
import '../screens/card_screen.dart';
import 'card_popup_menu.dart';

class CardTile extends StatelessWidget {
  final Flashcard flashcard;

  CardTile({required this.flashcard});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardScreen(flashcard: flashcard),
          ),
        );
      },
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thẻ #${flashcard.index}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons
                            .info, color: Theme.of(context).iconTheme.color,), // Replace 'Icons.info' with the desired icon
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CardScreen(flashcard: flashcard),
                            ),
                          );
                        },
                      ),
                      UserCardPopupMenu(
                        card: flashcard,
                        icon: Iconify(
                          Ri.more_2_fill,
                          color: Theme.of(context).iconTheme.color,
                          size: 30,
                        ),
                        isPopSecond: false,
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                height: 5,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Câu hỏi:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                flashcard.question,
                style: TextStyle(fontSize: 15),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),

              // Correct Answer
              Text(
                'Câu trả lời đúng:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                flashcard.correctAnswer,
                style: TextStyle(fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),

              // Wrong Answers
              Text(
                'Câu trả lời sai:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: flashcard.wrongAnswers.map((wrongAnswer) {
                  return Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      '●  $wrongAnswer',
                      style: TextStyle(fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
